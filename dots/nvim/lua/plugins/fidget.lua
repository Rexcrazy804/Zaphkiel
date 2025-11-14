return {
  "fidget.nvim",
  event = "LspAttach",
  after = function()
    require("fidget").setup({ notification = { window = { winblend = 0 } } })
  end,
}
