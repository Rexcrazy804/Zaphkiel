return {
  "mini.cursorword",
  event = "BufEnter",
  after = function()
    if vim.g.vscode then return end
    require("mini.cursorword").setup()
  end,
}
