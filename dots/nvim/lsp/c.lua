---@type vim.lsp.Config
return {
  cmd = { "ccls" },
  filetypes = { "c", "cpp" },
  root_markers = { ".ccls", ".git", "meson.build" },
  offset_encoding = "utf-32",

  workspace_required = true,
}
