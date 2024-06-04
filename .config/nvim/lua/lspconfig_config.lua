-- Change floating window borders
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = {
    { '🭽', 'FloatBorder' },
    { '▔', 'FloatBorder' },
    { '🭾', 'FloatBorder' },
    { '▕', 'FloatBorder' },
    { '🭿', 'FloatBorder' },
    { '▁', 'FloatBorder' },
    { '🭼', 'FloatBorder' },
    { '▏', 'FloatBorder' },
  },
})

-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Make root_dir the current directory ( not recommended )
local current_dir = function()
  return vim.fn.getcwd()
end

-- Servers
local servers = {
  'eslint',
  'clangd',
  'gopls',
  'texlab',
  'rust_analyzer',
  'solidity_ls_nomicfoundation',
  'vimls',
  'cmake',
  'pyright',
  'tsserver',
  'graphql',
  'bashls',
  'html',
  'cssls',
  'tailwindcss',
  'jsonls',
  'lua_ls',
  'ocamllsp',
  'yamlls',
  'taplo',
  'wgsl_analyzer',
}

-- Custom servers config
local custom_conf = {
  texlab = {
    settings = {
      latex = {
        build = {
          args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '-pvc' },
          forwardSearchAfter = true,
          onSave = true,
        },
        forwardSearch = {
          executable = 'zathura',
          args = {
            '-reuse-instance',
            '%p',
            '-forward-search',
            '%f',
            '%l',
          },
          onSave = true,
        },
      },
    },
  },
  pyright = {
    root_dir = current_dir,
  },
  jsonls = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
        end,
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            vim.env.VIMRUNTIME,
            '${3rd}/luv/library',
          },
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  tsserver = {
    init_options = {
      preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        importModuleSpecifierPreference = 'non-relative',
      },
    },
  },
  rust_analyzer = {
    settings = {
      ['rust_analyzer'] = {
        checkOnSave = {
          allFeatures = true,
          command = 'clippy',
          extraArgs = { '--no-deps' },
        },
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        procMacro = {
          enable = true,
          ignored = {
            ['async-trait'] = { 'async_trait' },
            ['napi-derive'] = { 'napi' },
            ['async-recursion'] = { 'async_recursion' },
          },
        },
      },
    },
  },
}

local get_conf = function(server)
  local capabilities_conf = {
    capabilities = capabilities,
  }
  if custom_conf[server] then
    local c = custom_conf[server]
    c.capabilities = capabilities_conf.capabilities
    return c
  end
  return capabilities_conf
end

for _, server in ipairs(servers) do
  require('lspconfig')[server].setup(get_conf(server))
end

-- Diagnostic signs
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
})

-- Keymaps
local keymap_opts = { silent = true }
local lsp_custom = require('lsp_custom')

vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'v' }, 'gra')
vim.keymap.del({ 'n' }, 'grr')

vim.keymap.set('n', 'gk', vim.lsp.buf.hover, keymap_opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.rename, keymap_opts)

vim.keymap.set('n', '<C-n>', lsp_custom.goto_next_diagnostic, keymap_opts)
vim.keymap.set('n', '<C-p>', lsp_custom.goto_prev_diagnostic, keymap_opts)
vim.keymap.set('n', 'gh', lsp_custom.toggle_buf_inlay_hints, keymap_opts)
vim.keymap.set('n', 'gd', lsp_custom.definition, keymap_opts)

vim.api.nvim_create_user_command(
  'Cd',
  require('lsp_custom').cd_project_root,
  {}
)

-- Remove formatexpr default
require('aug').add('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = nil
  end,
})
