return {
  "oil.nvim",
  lazy = false,
  keys = {
    {
      "<A-o>",
      require("oil").toggle_float,
      desc = "Open Oil floating window",
    },
  },
  after = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = true,
      keymaps = {
        ["H"] = { "actions.parent", mode = "n" },
        ["L"] = "actions.select",
        ["K"] = { "actions.open_cwd", mode = "n" },
        ["J"] = { "actions.cd", mode = "n" },
        ["<CR>"] = "actions.open_external",
        ["~"] = "<cmd>edit $HOME<CR>",
        ["gx"] = false,
        ["`"] = false,
        ["-"] = false,
        ["_"] = false,
        ["="] = false,
      },
    })
  end,
}
