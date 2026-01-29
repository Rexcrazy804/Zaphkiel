return {
  "mini.cursorword",
  event = "BufEnter",
  after = function() require("mini.cursorword").setup() end,
}
