return {
  "which-key.nvim",
  event = "DeferredUIEnter",
  after = function() require("which-key").setup({ preset = "modern" }) end,
}
