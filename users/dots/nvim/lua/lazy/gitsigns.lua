return {
  "gitsigns.nvim",
  event = "BufAdd",
  after = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]h", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Gitsigns: next hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[h", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Gitsigns: prev hunk" })

        -- Actions
        map(
          "n",
          "<leader>hs",
          gitsigns.stage_hunk,
          { desc = "Gitsigns: stage hunk" }
        )
        map(
          "n",
          "<leader>hu",
          gitsigns.undo_stage_hunk,
          { desc = "Gitsigns: unstage hunk" }
        )
        map(
          "n",
          "<leader>hr",
          gitsigns.reset_hunk,
          { desc = "Gitsigns: reset hunk" }
        )

        map(
          "v",
          "<leader>hs",
          function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end
        )
        map(
          "v",
          "<leader>hu",
          function()
            gitsigns.undo_stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end
        )
        map(
          "v",
          "<leader>hr",
          function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end
        )

        map(
          "n",
          "<leader>hS",
          gitsigns.stage_buffer,
          { desc = "Gitsigns: stage Buffer" }
        )
        map(
          "n",
          "<leader>hR",
          gitsigns.reset_buffer,
          { desc = "Gitsigns: reset Buffer" }
        )

        -- diffs
        map(
          "n",
          "<leader>hp",
          gitsigns.preview_hunk,
          { desc = "Gitsigns: preview hunk" }
        )
        map(
          "n",
          "<leader>hi",
          gitsigns.preview_hunk_inline,
          { desc = "Gitsigns: inline hunk" }
        )
      end,
    })
  end,
}
