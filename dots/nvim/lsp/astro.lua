---@type vim.lsp.Config
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro", "javascript", "typescript" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  init_options = {
    typescript = {
      tsdk = os.getenv("TSDK_LIB"),
    },
  },
}
