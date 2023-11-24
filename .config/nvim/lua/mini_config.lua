local modules = {
  'comment',
  'align',
  'surround',
  'pairs',
  'files',
  'hipatterns',
  'bracketed',
  'move',
  'starter',
  'pick',
  'extra',
}

local custom_conf = {
  comment = {
    options = {
      custom_commentstring = function()
        return require('ts_context_commentstring.internal').calculate_commentstring()
          or vim.bo.commentstring
      end,
    },
  },
  hipatterns = function()
    local hipatterns = require('mini.hipatterns')
    vim.keymap.set('n', '<leader>co', hipatterns.toggle)
    return {
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    }
  end,
  starter = function()
    local starter = require('mini.starter')
    local sections = {
      actions = {
        name = 'Actions',
        contents = {
          { name = 'plugins sync', action = 'Lazy sync' },
          { name = 'edit new buffer', action = 'enew' },
          { name = 'quit', action = 'qall' },
        },
      },
    }

    local parse_section = function(section)
      local t = section
      for i, content in ipairs(t.contents) do
        t.contents[i] = {
          name = content.name,
          action = content.action,
          section = t.name,
        }
      end
      return t
    end

    local format_text = function(str)
      local n = 60
      local formatted_str = ''
      local len = #str
      local i = 1
      while i < len do
        local pos
        if str:sub(i + n, i + n) == ' ' then
          pos = i + n
        else
          pos = str:find(' ', i + n) or len
        end
        formatted_str = formatted_str
          .. str:sub(i, pos):gsub('^%s*(.-)%s*$', '%1')
          .. '\n'
        i = pos
      end
      return formatted_str
    end

    local random_quote = function()
      local quotes = require('quotes')
      math.randomseed(os.time())
      local quote =
        vim.iter(quotes[math.random(#quotes)]):map(format_text):totable()
      local s = ''
      for _, sub in ipairs(quote) do
        s = s .. sub
      end
      return s
    end

    local header = function()
      return table.concat({
        'NVIM v' .. tostring(vim.version()),
        '',
        'Welcome to the Dark Side of text editing',
        'Nvim is open source and freely distributable',
        '',
        random_quote(),
        '     o       ⌌━━━ ⌍',
        '      o     | //   ░',
        '       o  _/,-||-_╲_\\',
        '          / (■)(■)\\\\░\\',
        '         / \\_/_\\__/\\  ╲',
        '        (   ╱╱ii\\/ )  \\_',
        '         ╲▁  ▔▔▔▔─⌍▁▁▁▁▁/',
        '          ▁▁▐ ▐  ▐ \\',
      }, '\n')
    end

    return {
      evaluate_single = true,
      header = header(),
      items = {
        starter.sections.recent_files(5, true, false),
        parse_section(sections.actions),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.indexing('all', { sections.actions.name }),
        starter.gen_hook.padding(2, 1),
      },
      footer = '',
    }
  end,
  pick = function()
    local pick = require('mini.pick')
    local extra = require('mini.extra')
    local win_config = function()
      local height = math.floor(0.8 * vim.o.lines)
      local width = math.floor(0.8 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.3 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end

    local get_branch = function(item)
      return item:match('^%*?%s*(%S+)')
    end

    local get_repo_dir = function()
      return pick.get_picker_opts().source.cwd
    end

    local choose_checkout = function(item)
      vim.fn.system({
        'git',
        '-C',
        get_repo_dir(),
        'checkout',
        get_branch(item),
      })
    end

    local show_branch_history = function(buf_id, item)
      local cmd = { 'git', '-C', get_repo_dir(), 'l', get_branch(item) }
      local lines = vim.fn.systemlist(cmd)
      vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    end

    pick.registry.git_branches = function(local_opts)
      extra.pickers.git_branches(
        local_opts,
        { source = { choose = choose_checkout, preview = show_branch_history } }
      )
    end

    pick.registry.config = function()
      return pick.builtin.cli({
        command = {
          'fd',
          '--type=f',
          '--no-follow',
          '--color=never',
          '--no-ignore',
        },
      }, {
        source = {
          name = 'Config',
          cwd = vim.fn.stdpath('config'),
        },
      })
    end

    pick.registry.spell_suggest = function(local_opts)
      extra.pickers.spellsuggest(local_opts, {
        source = {
          name = ('Spell suggestions (%s) for %s'):format(
            string.upper(vim.api.nvim_buf_get_option(0, 'spelllang')),
            vim.inspect(vim.fn.expand('<cword>'))
          ),
        },
      })
    end

    pick.registry.lsp_references = function()
      extra.pickers.lsp({ scope = 'references' })
    end

    pick.registry.lsp_symbols = function()
      extra.pickers.lsp({ scope = 'document_symbol' })
    end

    pick.registry.grep_string = function()
      pick.builtin.grep({ pattern = vim.fn.expand('<cword>') })
    end

    vim.keymap.set('n', ',,', pick.builtin.files)
    vim.keymap.set('n', ',g', pick.builtin.grep_live)
    vim.keymap.set('n', ',h', pick.builtin.help)

    vim.keymap.set('n', ',t', extra.pickers.treesitter)

    vim.keymap.set('n', ',s', pick.registry.grep_string)
    vim.keymap.set('n', ',r', pick.registry.lsp_references)
    vim.keymap.set('n', ',a', pick.registry.lsp_symbols)
    vim.keymap.set('n', ',b', pick.registry.git_branches)
    vim.keymap.set('n', ',c', pick.registry.config)
    vim.keymap.set('n', 'z=', pick.registry.spell_suggest)

    return {
      mappings = {
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
        delete_left = '',
      },
      source = {
        preview = function(buf_id, item)
          pick.default_preview(buf_id, item, {
            n_context_lines = 10000,
          })
        end,
        show = function(buf_id, items, query)
          pick.default_show(buf_id, items, query, {
            show_icons = true,
            icons = {
              directory = ' ',
              file = ' ',
            },
          })
        end,
      },
      window = {
        config = win_config,
      },
    }
  end,
}

local get_conf = function(module)
  local t = type(custom_conf[module])
  if t == 'table' then
    return custom_conf[module]
  end
  if t == 'function' then
    return custom_conf[module]()
  end
  return {}
end

for _, module in ipairs(modules) do
  require('mini.' .. module).setup(get_conf(module))
end
