require('lz.n').load {
  "nvim-cmp",
  event = "InsertEnter",
  after = function()
    require('lz.n').trigger_load({ "lspkind.nvim" })
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    cmp.setup({
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
        }),
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp',                priority = 1000 },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lsp_document_symbol' },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'treesitter' },
      }),
    })
  end,
}

vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities()
})
