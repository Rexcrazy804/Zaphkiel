return {
  "flash.nvim",
  event = "BufReadPost",
  keys = {
    {
      "<leader>/",
      "<CMD>lua require('flash').jump()<CR>",
      desc = "FLASH jump",
    },
  },
  after = function()
    if vim.g.vscode then return end
    require("flash").setup({
      search = { mode = "fuzzy" },
      modes = { search = { enabled = true } },
    })
  end,
}
