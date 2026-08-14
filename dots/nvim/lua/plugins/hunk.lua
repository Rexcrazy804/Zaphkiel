return {
  "hunk.nvim",
  cmd = "DiffEditor",
  beforeAll = function()
    require("hunk").setup({
      ui = {
        tree = {
          mode = "flat",
        },
      },
    })
  end,
}
