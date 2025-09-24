return {
  "fzf-lua",
  keys = {
    -- files and buffers
    { "<leader>ff", "<CMD>FzfLua files<CR>", desc = "Find Files" },
    { "<leader>fb", "<CMD>FzfLua buffers<CR>", desc = "Find Buffers" },
    {
      "<leader>fo",
      "<CMD>FzfLua oldfiles<CR>",
      desc = "Find recently opened files",
    },
    {
      "<leader>fw",
      "<CMD>FzfLua live_grep_native<CR>",
      desc = "Find in all Files",
    },
    {
      "<leader>f/",
      "<CMD>FzfLua lgrep_curbuf<CR>",
      desc = "Find in current buffer",
    }, -- git stuff
    { "<leader>gc", "<CMD>FzfLua git_commits<CR>", desc = "Find git commits" },
    {
      "<leader>gbc",
      "<CMD>FzfLua git_bcommits<CR>",
      desc = "Find git commits of current buffer",
    },
    { "<leader>gs", "<CMD>FzfLua git_status<CR>", desc = "Show git status" },
    { "<leader>gbr", "<CMD>FzfLua git_branches<CR>", desc = "Show git branches" },

    -- lsp
    {
      "<leader>fd",
      "<CMD>FzfLua diagnostics_document<CR>",
      desc = "Find Lsp Diagnostics",
    }, -- neovim Yugoslavian
    { "<leader>ft", "<CMD>FzfLua colorschemes<CR>", desc = "Pick Theme" },
    {
      "<leader>fc",
      "<CMD>FzfLua command_history<CR>",
      desc = "Find old commands",
    },
    { "<leader>fs", "<CMD>FzfLua spellcheck<CR>", desc = "Find mispelt words" },
    { "z=", "<CMD>FzfLua spell_suggest<CR>", desc = "List suggested spellings" },

    -- special
    { "<leader>fz", "<CMD>FzfLua zoxide<CR>", desc = "Find Zoxide jump" },
    { "<leader>fa", "<CMD>FzfLua global<CR>", desc = "Find Global" },
    { "<leader>f,", "<CMD>FzfLua resume<CR>", desc = "Resume last find" },
  },
  after = function()
    require("fzf-lua").setup({
      actions = { files = { ["enter"] = FzfLua.actions.file_edit } },
    })
  end,
}
