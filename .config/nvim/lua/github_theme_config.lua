-- Example config in Lua
require('github-theme').setup({
  options = {
    transparent = true,
    hide_end_of_buffer = true,
    hide_nc_statusline = true,
    styles = {
      comments = 'NONE',
      functions = 'NONE',
      keywords = 'NONE',
      variables = 'NONE',
    },
    darken = {
      floats = true,
      sidebars = {
        enable = true,
        list = {},
      },
    },
  },

  specs = {
    -- Change the color of only the 'github_dark' theme's 'hint' color to magenta and make the 'error' color a dim red.
    -- github_dark = {
    --   diag = {
    --     error = '#660000',
    --     hint = 'magenta.base',
    --   },
    -- },
    -- Change the "hint" color to the "orange" color, and make the "error" color bright red.
    all = {
      diag = {
        error = '#ff0000',
        hint = 'orange',
      },
    },
  },

  -- Overwrite the highlight groups for all colorschemes
  groups = {
    all = {
      -- htmlTag = { fg = 'palette.red', bg = '#282c34', sp = 'diag.hint', style = 'underline,bold' },
      DiagnosticHint = { link = 'LspDiagnosticsDefaultHint' },
      -- this will remove the highlight groups
      -- TSField = {},
    },
  },
})
