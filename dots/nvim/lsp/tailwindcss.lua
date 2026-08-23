---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server" },
  filetypes = {
    -- html
    "astro",
    "astro-markdown",
    "html",
    -- css
    "css",
    "scss",
    -- js
    "javascript",
  },
  root_markers = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
    ".jj",
  },
}
