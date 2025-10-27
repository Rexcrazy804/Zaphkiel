---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { ".git", "Cargo.lock" },
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
        invocationLocation = "workspace",
        features = "all",
        extraArgs = {
          "--",
          "--no-deps",
          "-Dclippy::correctness",
          "-Dclippy::complexity",
          "-Wclippy::perf",
          "-Wclippy::pedantic",
        },
      },
      diagnostics = {
        enable = true,
        styleLints = { enable = true },
        experimental = { enable = true },
      },
      rustfmt = { rangeFormatting = { enable = true } },
    },
  },
}
