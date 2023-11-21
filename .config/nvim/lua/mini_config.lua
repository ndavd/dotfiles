local modules = {
  'comment',
  'align',
  'surround',
  'pairs',
  'files',
  'hipatterns',
  'bracketed',
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
    local p = function(word)
      return '%f[%w]()' .. word .. '()%f[%W]'
    end
    return {
      highlighters = {
        fix = { pattern = p('FIX'), group = 'MiniHipatternsFixme' },
        fixme = { pattern = p('FIXME'), group = 'MiniHipatternsFixme' },
        hack = { pattern = p('HACK'), group = 'MiniHipatternsHack' },
        todo = { pattern = p('TODO'), group = 'MiniHipatternsTodo' },
        pending = { pattern = p('PENDING'), group = 'MiniHipatternsTodo' },
        note = { pattern = p('NOTE'), group = 'MiniHipatternsNote' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
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
