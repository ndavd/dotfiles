-- Change floating window borders
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
    },
  }
)
-- Enable (broadcasting) snippet capability for completion
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- Make root_dir the current directory ( not recommended )
local current_dir = function() return vim.fn.getcwd() end

-- PID
-- local pid = vim.fn.getpid()

-- Eslint
require'lspconfig'.eslint.setup{}

-- C, C++
require'lspconfig'.clangd.setup{
  capabilities = capabilities,
}

-- Go
require'lspconfig'.gopls.setup{
  capabilities = capabilities,
}

-- LaTeX
require'lspconfig'.texlab.setup{
  settings = {
    latex = {
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-pvc" },
        forwardSearchAfter=true,
        onSave = true,
      },
      forwardSearch = {
        executable = "zathura",
        args = {
          "-reuse-instance",
          "%p",
          "-forward-search",
          "%f",
          "%l",
        },
        onSave=true,
      },
    }
  }
}

-- Rust
require'lspconfig'.rust_analyzer.setup{
  capabilities = capabilities,
}

-- Solidity
require'lspconfig'.solidity_ls.setup{
  capabilities = capabilities,
  settings = {
    solidity = {
      nodemodulespackage = "solc",
      compileUsingRemoteVersion = "latest",
      compilerOptimization = 200,
      compileUsingLocalVersion = "",
      defaultCompiler = "remote", -- remote | localFile | localNodeModule | embedded
      linter = "solhint", -- solhint | solium
      enabledAsYouTypeCompilationErrorCheck = true,
      validationDelay = 1500,
      packageDefaultDependenciesDirectory = "node_modules",
      packageDefaultDependenciesContractsDirectory = "",
    }
  }
}

-- Vimscript
require'lspconfig'.vimls.setup{
  capabilities = capabilities,
}

-- Cmake
require'lspconfig'.cmake.setup{
  capabilities = capabilities,
}

-- Python
require'lspconfig'.pyright.setup{
  root_dir = current_dir,
  capabilities = capabilities,
}

-- JavaScript, TypeScript
require'lspconfig'.tsserver.setup{
  root_dir = current_dir,
  capabilities = capabilities,
}

-- Graphql
require'lspconfig'.graphql.setup{
  capabilities = capabilities,
}

-- Bash
require'lspconfig'.bashls.setup{
  capabilities = capabilities,
}

-- Html
require'lspconfig'.html.setup{
  capabilities = capabilities,
}

-- Css
require'lspconfig'.cssls.setup{
  capabilities = capabilities,
}

-- Tailwindcss
require'lspconfig'.tailwindcss.setup{
  capabilities = capabilities,
}

-- Json
require'lspconfig'.jsonls.setup{
  capabilities = capabilities,
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
    }
  }
}

-- Lua
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {"lua-language-server", "-E", "/usr/lib/lua-language-server/main.lua"};
  root_dir = current_dir,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
