vim.o.number = true
vim.o.termguicolors = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.signcolumn = "yes"

-- tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

-- search?
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.wrap = false

vim.o.scrolloff = 5
vim.g.mapleader = " ";

-- inline hints .w.
-- mfing breaking changes I will fight you
vim.diagnostic.config({ virtual_text = true })
