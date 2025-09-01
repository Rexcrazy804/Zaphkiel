---@type vim.lsp.Config
return {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  root_markers = {
    "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml"
  },
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      cabalFormattingProvider = "cabalfmt"
    }
  }
}
