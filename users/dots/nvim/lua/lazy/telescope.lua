return {
  "telescope.nvim",
  keys = {
    { "<leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fb", "<CMD>Telescope buffers<CR>", desc = "Find Buffers" }, {
      "<leader>fc",
      "<CMD>Telescope command_history<CR>",
      desc = "Find old commands"
    },
    { "<leader>fg", "<CMD>Telescope git_commits<CR>", desc = "Find git commits" },
    { "<leader>fj", "<CMD>Telescope jumplist<CR>", desc = "Find jumps" },
    {
      "<leader>fw",
      "<CMD>Telescope live_grep<CR>",
      desc = "Find within all Files"
    }, {
      "<leader>fo",
      "<CMD>Telescope oldfiles<CR>",
      desc = "Find recently opened files"
    },
    {
      "<leader>fd",
      "<CMD>Telescope diagnostics<CR>",
      desc = "Find Lsp Diagnostics"
    }, {
      "<leader>fls",
      "<CMD>Telescope lsp_document_symbols<CR>",
      desc = "Find LSP document symbols"
    }, {
      "<leader>flw",
      "<CMD>Telescope lsp_workspace_symbols<CR>",
      desc = "Find LSP workspace symbols"
    }
  },

  after = function()
    require("telescope").setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending"
      },

      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        }
      }
    })
    require("telescope").load_extension("fzf")
  end
}
