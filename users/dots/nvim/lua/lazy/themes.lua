return {
  {
    "catppuccin-nvim",
    colorscheme = {
      "catppuccin",
      "catppuccin-frappe",
      "catppuccin-latte",
      "catppuccin-macchiato",
      "catppuccin-mocha",
    },
    after = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = false,
      })
    end,
  },
  {
    "rose-pine",
    colorscheme = {
      "rose-pine",
      "rose-pine-dawn",
      "rose-pine-main",
      "rose-pine-moon",
    },
    after = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },
        styles = { bold = true, italic = true, transparency = true },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",
          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",
          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
        highlight_groups = {
          -- leafy search
          CurSearch = { fg = "base", bg = "leaf", inherit = false },
          Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },

          -- make blink transparent
          BlinkCmpDoc = { bg = "NONE" },
          BlinkCmpDocSeparator = { bg = "NONE" },
          BlinkCmpScrollBarGutter = { bg = "NONE" },
          -- here to let you know that I tried my fucking best to get rid of
          -- the transparency of whatever that shit is called but failed after
          -- a fuck tone of tries thank god devMode exists otherwise I would
          -- have kms'd
        },
      })
    end,
  },
  {
    "dracula.nvim",
    colorscheme = { "dracula", "dracula-soft" },
    after = function()
      local dracula = require("dracula")
      dracula.setup({
        transparent_bg = true,
        italic_comment = true,
        overrides = {},
      })
    end,
  },
}
