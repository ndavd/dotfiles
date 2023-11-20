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
    local frontier_p = function(word)
      return '%f[%w]()' .. word .. '()%f[%W]'
    end

    return {
      highlighters = {
        fix = { pattern = frontier_p('FIX'), group = 'MiniHipatternsFixme' },
        fixme = { pattern = frontier_p('FIXME'), group = 'MiniHipatternsFixme' },
        hack = { pattern = frontier_p('HACK'), group = 'MiniHipatternsHack' },
        todo = { pattern = frontier_p('TODO'), group = 'MiniHipatternsTodo' },
        note = { pattern = frontier_p('NOTE'), group = 'MiniHipatternsNote' },
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
