vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    -- stop folding my shit
    -- vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo[0][0].foldmethod = 'expr'
  end,
})
