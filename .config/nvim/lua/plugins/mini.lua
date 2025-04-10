local aug = require('aug')

local modules = {
  'ai',
  'align',
  'bracketed',
  'colors',
  'comment',
  'diff',
  'extra',
  'git',
  'hipatterns',
  'move',
  'pairs',
  'pick',
  'starter',
  'surround',
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

    local greeting = function()
      local parts = { 'evening', 'morning', 'afternoon', 'evening' }
      local hour = tonumber(vim.fn.strftime('%H'))
      local day_part = parts[math.floor((hour + 4) / 8) + 1]
      local username = vim.uv.os_get_passwd()['username']
      return ('Good %s, %s'):format(day_part, username)
    end

    local header = function()
      return table.concat({
        'NVIM v' .. tostring(vim.version()),
        greeting(),
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
          local name = require('plugins.webdevicons').get_icon({
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
      vim.system({
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

    vim.ui.select = pick.ui_select

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
        prompt_caret = '▁',
      },
    }
  end,
  git = function()
    -- Set the summary string to just the branch
    local format_summary_string = function(data)
      vim.b[data.buf].minigit_summary_string =
        vim.b[data.buf].minigit_summary.head_name
    end

    aug.add(
      'User',
      { pattern = 'MiniGitUpdated', callback = format_summary_string }
    )

    return {
      command = {
        split = 'vertical',
      },
    }
  end,
  diff = function()
    local format_summary_string = function(data)
      local summary = vim.b[data.buf].minidiff_summary
      if summary == nil then
        vim.b[data.buf].minidiff_summary_string = ''
        return
      end
      local stats = {}
      if summary.add ~= nil and summary.add > 0 then
        table.insert(stats, '+' .. summary.add)
      end
      if summary.delete ~= nil and summary.delete > 0 then
        table.insert(stats, '-' .. summary.delete)
      end
      if summary.change ~= nil and summary.change > 0 then
        table.insert(stats, '~' .. summary.change)
      end
      if #stats == 0 then
        vim.b[data.buf].minidiff_summary_string = ''
        return
      end
      vim.b[data.buf].minidiff_summary_string = ('[%s]'):format(
        table.concat(stats, ',')
      )
    end
    aug.add(
      'User',
      { pattern = 'MiniDiffUpdated', callback = format_summary_string }
    )

    local diff_sign = '▌'

    return {
      view = {
        style = 'sign',
        signs = { add = diff_sign, change = diff_sign, delete = diff_sign },
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
