return {
  "indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  after = function()
    -- disable indent blankline in neovim-vscode
    -- why does the illustrous rexi require crappy vscode?
    -- plsql support ,w,
    -- one day I could write my own plugin for the same
    -- but I am one lazy lass
    if vim.g.vscode then return end
    require("ibl").setup({
      scope = {
        show_end = false,
        show_exact_scope = false,
        show_start = false,
      },
    })
  end,
}
