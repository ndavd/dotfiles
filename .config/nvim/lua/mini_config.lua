local modules = {
  'ai',
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

local icons = {
  directory = ' ',
  file = ' ',
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
  files = function()
    local prefix = function(fs_entry)
      if fs_entry.fs_type == 'directory' then
        return icons.directory, 'MiniFilesDirectory'
      end
      local icon, hl = require('nvim-web-devicons').get_icon(fs_entry.name)
      return icon .. ' ', hl
    end

    return {
      content = { prefix = prefix },
    }
  end,
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

    local sections = {
      actions = 'Actions',
      recent_files = 'Recent files',
    }

    local actions = function()
      local section = sections.actions
      return {
        { name = 'plugins sync', action = 'Lazy sync', section = section },
        { name = 'edit new buffer', action = 'enew', section = section },
        { name = 'quit', action = 'qall', section = section },
      }
    end

    local recent_files = function(n)
      n = n or 5
      return function()
        local files = vim.tbl_filter(function(f)
          return vim.fn.filereadable(f) == 1
        end, vim.v.oldfiles or {})

        if #files == 0 then
          return {
            {
              name = 'There are no recent files (`v:oldfiles` is empty)',
              action = '',
            },
          }
        end

        local cwd_pattern = ('^%s/'):format(vim.pesc(vim.fn.getcwd()))
        files = vim.tbl_filter(function(f)
          return f:find(cwd_pattern) ~= nil
        end, files)

        if #files == 0 then
          return {
            {
              name = 'There are no recent files in current directory',
              action = '',
            },
          }
        end

        local items = {}
        for _, f in ipairs(vim.list_slice(files, 1, n)) do
          local name = require('webdevicons_config').get_icon({
            filepath = f,
          }) .. vim.fn.fnamemodify(f, ':~:.')
          table.insert(items, {
            name = name,
            action = 'edit ' .. f,
            section = sections.recent_files,
          })
        end

        return items
      end
    end

    return {
      evaluate_single = true,
      header = header(),
      items = {
        recent_files,
        actions,
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.indexing('all', { sections.actions }),
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

    local load_temp_rg = function(f)
      local rg_env = 'RIPGREP_CONFIG_PATH'
      local cached_rg_config = vim.uv.os_getenv(rg_env) or ''
      vim.uv.os_setenv(rg_env, vim.fn.stdpath('config') .. '/.rg')
      f()
      vim.uv.os_setenv(rg_env, cached_rg_config)
    end

    local get_branch = function(item)
      return item:match('^%*?%s*(%S+)')
    end

    local get_repo_dir = function()
      return pick.get_picker_opts().source.cwd
    end

    local checkout_branch = function(branch)
      vim.fn.system({
        'git',
        '-C',
        get_repo_dir(),
        'checkout',
        branch,
      })
    end

    local choose_checkout = function(item)
      local branch = get_branch(item)
      local remote = branch:match('^remotes/(.-)/')
      if remote == nil then
        checkout_branch(branch)
        return
      end
      local local_branch = branch:match('^remotes/' .. remote .. '/(.*)')
      checkout_branch(local_branch)
    end

    local show_branch_history = function(buf_id, item)
      local cmd = { 'git', '-C', get_repo_dir(), 'l', get_branch(item) }
      local lines = vim.fn.systemlist(cmd)
      vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    end

    pick.registry.git_branches = function(local_opts)
      extra.pickers.git_branches(local_opts, {
        source = { choose = choose_checkout, preview = show_branch_history },
      })
    end

    pick.registry.config = function()
      return pick.builtin.cli({
        command = {
          'rg',
          '--files',
          '--no-follow',
          '--color=never',
          '--no-ignore',
          '--hidden',
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
            string.upper(
              vim.api.nvim_get_option_value('spelllang', { buf = 0 })
            ),
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

    pick.registry.f = function()
      load_temp_rg(function()
        pick.builtin.files({ tool = 'rg' })
      end)
    end

    pick.registry.gl = function()
      load_temp_rg(function()
        pick.builtin.grep_live({ tool = 'rg' })
      end)
    end

    pick.registry.gs = function()
      load_temp_rg(function()
        pick.builtin.grep({ pattern = vim.fn.expand('<cword>'), tool = 'rg' })
      end)
    end

    vim.keymap.set('n', ',,', pick.registry.f)
    vim.keymap.set('n', ',g', pick.registry.gl)
    vim.keymap.set('n', ',s', pick.registry.gs)
    vim.keymap.set('n', ',r', pick.registry.lsp_references)
    vim.keymap.set('n', ',a', pick.registry.lsp_symbols)
    vim.keymap.set('n', ',b', pick.registry.git_branches)
    vim.keymap.set('n', ',c', pick.registry.config)
    vim.keymap.set('n', 'z=', pick.registry.spell_suggest)
    vim.keymap.set('n', ',h', pick.builtin.help)

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
            icons = icons,
          })
        end,
      },
      window = {
        config = win_config,
        prompt_cursor = '▁',
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
