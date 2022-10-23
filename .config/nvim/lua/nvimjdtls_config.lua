-- Create `java-lsp.bat` and add it to $PATH
-- Put the following there:
--    java -Declipse.application=org.eclipse.jdt.ls.core.id1
--    -Dosgi.bundles.defaultStartLevel=4
--    -Declipse.product=org.eclipse.jdt.ls.core.product -Dlog.protocol=true
--    -Dlog.level=ALL -Xms1g -Xmx2G -jar
--    C:/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/
--    plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar -configuration
--    "C:/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_win"
--    -data "C:/eclipse.jdt.ls/workspace" --add-modules=ALL-SYSTEM --add-opens
--    java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED

-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('jdtls').start_or_attach({
  capabilities = capabilities,
  cmd = { 'java-lsp.bat' },
  root_dir = vim.fn.getcwd(),
})
