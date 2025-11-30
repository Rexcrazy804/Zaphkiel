---@type vim.lsp.Config
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".git",
    "meson.build",
  },

  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-8", "utf-16" },
  },

  on_init = function(client, init_result)
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,
}
