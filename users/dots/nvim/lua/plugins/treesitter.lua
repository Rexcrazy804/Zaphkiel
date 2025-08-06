require("lz.n").load {
  "nvim-treesitter",
  event = "FileType",
  after = function()
    require("nvim-treesitter.configs").setup({
      sync_install = false,
      auto_install = false,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = false,
          node_decremental = "<A-CR>",
          node_incremental = "<CR>"
          -- scope_incremental = "grc",
        }
      },
      indent = { enable = true }
    })
    -- don't fold by default .w. -- AL:KSDJ ASJDKL: AJSDKL: FUCK THIS FOLDING MOTHERFUCAKJL
    -- MADE FUCKING TOGGLE TERM SO SLOW THAT I WANTED TO KMS <ASDJ ASJDK AL>
    -- vim.opt.foldenable = false
    -- vim.wo.foldmethod = 'expr'
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
}
