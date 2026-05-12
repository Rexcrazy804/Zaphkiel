return {
  "which-key.nvim",
  event = "DeferredUIEnter",
  after = function()
    if vim.g.vscode then return end
    require("which-key").setup({ preset = "modern" })
  end,
}
