local lsp_custom = require('lsp_custom')

-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Make root_dir the current directory (not recommended)
local current_dir = function()
  return vim.fn.getcwd()
end

-- Servers
local servers = {
  'bashls',
  'clangd',
  'cmake',
  'cssls',
  'eslint',
  'gopls',
  'graphql',
  'html',
  'jsonls',
  'lua_ls',
  'ocamllsp',
  'pyright',
  'rust_analyzer',
  'solidity_ls',
  'tailwindcss',
  'taplo',
  'texlab',
  'ts_ls',
  'vimls',
  'glasgow',
  'yamlls',
  'dockerls',
  'prismals',
  'astro',
  'sqls',
  'nixd',
  'biome',
}

-- Custom servers config
local custom_conf = {
  texlab = {
    settings = {
      texlab = {
        build = {
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
  ts_ls = {
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
  solidity_ls = {
    settings = {
      solidity = {
        compileUsingRemoteVersion = lsp_custom.get_solc_version(),
        defaultCompiler = 'remote',
        enabledAsYouTypeCompilationErrorCheck = true,
        validationDelay = 1500,
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
  vim.lsp.config(server, get_conf(server))
  vim.lsp.enable(server)
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

vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'v' }, 'gra')
vim.keymap.del({ 'n' }, 'grr')
vim.keymap.del({ 'n' }, 'gri')

vim.keymap.set('n', 'gk', vim.lsp.buf.hover, keymap_opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.rename, keymap_opts)
vim.keymap.set('n', 'g?', vim.lsp.buf.code_action, keymap_opts)

vim.keymap.set('n', '<C-n>', lsp_custom.goto_next_diagnostic, keymap_opts)
vim.keymap.set('n', '<C-p>', lsp_custom.goto_prev_diagnostic, keymap_opts)
vim.keymap.set('n', 'gv', lsp_custom.toggle_diagnostic_virt_lines, keymap_opts)
vim.keymap.set('n', 'gi', lsp_custom.toggle_buf_inlay_hints, keymap_opts)
vim.keymap.set('n', 'gd', lsp_custom.definition, keymap_opts)

-- Commands

vim.api.nvim_create_user_command('Cd', lsp_custom.cd_project_root, {})

vim.api.nvim_create_user_command('Solc', function()
  vim.cmd('split ' .. lsp_custom.get_solc_version_path())
end, {})

-- Remove formatexpr default
require('aug').add('LspAttach', {
  callback = function(ev)
    vim.bo[ev.buf].formatexpr = nil
  end,
})

-- Enable textDocument/documentColor if available
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client:supports_method('textDocument/documentColor') then
      vim.lsp.document_color.enable(true, args.buf, { style = 'virtual' })
    end
  end,
})
