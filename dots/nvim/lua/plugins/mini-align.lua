return {
  "mini.align",
  event = "BufEnter",
  after = function() require("mini.align").setup() end,
}
