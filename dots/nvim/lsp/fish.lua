---@type vim.lsp.Config
return {
  cmd = { "fish-lsp", "start" },
  filetypes = { "fish" },
  root_markers = { ".git", "config.fish" },
}
