return {
  "neo-tree.nvim",
  keys = { { "<C-n>", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" } },
  after = function() require("neo-tree").setup() end,
}
