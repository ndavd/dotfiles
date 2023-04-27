local out = {}
local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix = ' > ',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'ascending',
    layout_strategy = 'flex',
    layout_config = {
      flex = {
        flip_columns = 150,
      },
      prompt_position = 'top',
      width = 0.95,
      horizontal = {
        preview_width = 0.45,
      },
      vertical = {
        preview_height = 0.6,
      },
    },
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = { 'misc/*', 'notes/*' },
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    disable_devicons = vim.env.TERM ~= 'linux',
    color_devicons = vim.env.TERM ~= 'linux',
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    -- -- Developer configurations: Not meant for general override
    -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
  },
  extensions = {
    frecency = {
      show_scores = true,
    },
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    fzf_writer = {
      minimum_grep_characters = 2,
      minimum_files_characters = 2,

      -- Disabled by default.
      -- Will probably slow down some aspects of the sorter, but can make color highlights.
      -- I will work on this more later.
      use_highlighter = true,
    },
  },
})

-- Load extensions
require('telescope').load_extension('frecency')
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('fzf_writer')

-- Search config dir
out.search_config = function()
  require('telescope.builtin').find_files({
    prompt_title = 'CONFIG',
    cwd = vim.fn.stdpath('config'),
    no_ignore = true,
  })
end

-- Git branches
out.git_branches = function()
  require('telescope.builtin').git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-e>', actions.git_delete_branch)
      map('n', '<c-e>', actions.git_delete_branch)
      return true
    end,
  })
end

return out
