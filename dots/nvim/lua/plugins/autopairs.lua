return {
  "nvim-autopairs",
  event = "InsertEnter",
  after = function()
    if vim.g.vscode then return end
    require("nvim-autopairs").setup()
  end,
}
