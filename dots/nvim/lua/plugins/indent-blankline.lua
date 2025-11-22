return {
  "indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  after = function()
    require("ibl").setup({
      scope = {
        show_end = false,
        show_exact_scope = false,
        show_start = false,
      },
    })
  end,
}
