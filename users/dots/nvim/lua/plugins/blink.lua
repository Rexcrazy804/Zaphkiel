require('lz.n').load {
  'blink.cmp',
  event = "InsertEnter",
  after = function()
    require('blink-cmp').setup({
      keymap = {
        preset = 'enter',
        ['<right>'] = { 'accept' },
        ['<down>'] = { 'show', 'select_next' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = {
          border = 'single',
          auto_show = false,
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              }
            }
          }
        },
        ghost_text = { enabled = true },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,

          window = { border = 'single' },
        }
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    })
  end
}
