return {
  "toggleterm.nvim",
  keys = {
    {
      "<A-i>",
      "<CMD>ToggleTerm direction=float<CR>",
      desc = "Floating Term",
    },
  },
  after = function()
    require("toggleterm").setup({
      autochdir = true,
      highlights = require("rose-pine.plugins.toggleterm"),
      shade_terminals = true,
      direction = "float",
      open_mapping = [[<A-i>]],
    })
  end,
}
