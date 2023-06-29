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

local servers = {
  'eslint',
  'clangd',
  'gopls',
  'texlab',
  'rust_analyzer',
  'solidity_ls',
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
}

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
  solidity_ls = {
    capabilities = capabilities,
    settings = {
      solidity = {
        nodemodulespackage = 'solc',
        compileUsingRemoteVersion = 'latest',
        compilerOptimization = 200,
        compileUsingLocalVersion = '',
        defaultCompiler = 'remote', -- remote | localFile | localNodeModule | embedded
        linter = 'solhint', -- solhint | solium
        enabledAsYouTypeCompilationErrorCheck = true,
        validationDelay = 1500,
        packageDefaultDependenciesDirectory = 'node_modules',
        packageDefaultDependenciesContractsDirectory = '',
      },
    },
  },
  pyright = {
    root_dir = current_dir,
    capabilities = capabilities,
  },
  jsonls = {
    capabilities = capabilities,
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
          library = vim.api.nvim_get_runtime_file('', true),
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

local function get_conf(server)
  if custom_conf[server] then
    return custom_conf[server]
  end
  return { capabilities = capabilities }
end

for _, server in pairs(servers) do
  require('lspconfig')[server].setup(get_conf(server))
end
