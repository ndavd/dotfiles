local modules = {
  'comment',
  'align',
  'surround',
  'pairs',
  'files',
  'hipatterns',
  'bracketed',
  'starter',
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

    local random_quote = function()
      local quotes = require('quotes')
      math.randomseed(os.time())
      local quote = vim
        .iter(quotes[math.random(#quotes)])
        :map(function(str)
          return vim.fn.system('fold -w 60 -s <(echo "' .. str .. '")')
        end)
        :totable()
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
