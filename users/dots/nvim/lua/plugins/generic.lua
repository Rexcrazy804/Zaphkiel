return {
  {
    "neo-tree.nvim",
    keys = { { "<C-n>", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" } },
    after = function() require("neo-tree").setup() end,
  },
  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function() require("which-key").setup({ preset = "modern" }) end,
  },
  {
    "toggleterm.nvim",
    keys = {
      {
        "<A-i>",
        "<CMD>ToggleTerm direction=float<CR>",
        desc = "Floating Term",
      },
    },
    after = function()
      require("toggleterm").setup({
        autochdir = true,
        highlights = require("rose-pine.plugins.toggleterm"),
        shade_terminals = true,
        direction = "float",
        open_mapping = [[<A-i>]],
      })
    end,
  },
  {
    "lualine.nvim",
    event = "VimEnter",
    after = function()
      require("lualine").setup({
        tabline = {
          lualine_a = { { "buffers", symbols = { alternate_file = "" } } },
        },
        options = {
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          theme = "auto",
        },
      })
    end,
  },
  {
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
  },
  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function() require("nvim-autopairs").setup() end,
  },
  {
    "flash.nvim",
    event = "BufReadPost",
    keys = {
      {
        "<leader>/",
        "<CMD>lua require('flash').jump()<CR>",
        desc = "FLASH jump",
      },
    },
    after = function()
      require("flash").setup({
        search = { mode = "fuzzy" },
        modes = { search = { enabled = true } },
      })
    end,
  },
  {
    "fidget.nvim",
    event = "LspAttach",
    after = function()
      require("fidget").setup({ notification = { window = { winblend = 0 } } })
    end,
  },
}
