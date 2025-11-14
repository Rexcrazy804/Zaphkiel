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
        ["?"] = "actions.show_help",
        ["."] = "actions.toggle_hidden",
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["H"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["q"] = "actions.close",
        ["gh"] = { "<cmd>edit $HOME<CR>", mode = "n", desc = "jump to $HOME" },
        ["gt"] = "actions.toggle_trash",
        ["<CR>"] = "actions.open_external",

        -- disable default binds
        ["~"] = false,
        ["-"] = false,
        ["_"] = false,
        ["="] = false,
        ["g."] = false,
        ["g?"] = false,
        ["gx"] = false,
        ["g\\"] = false,
        ["<C-c>"] = false,
      },
    })
  end,
}
