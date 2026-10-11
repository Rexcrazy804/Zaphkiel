-- someone tell why netrw Lexplore decides to fucking open
-- a new file in its fucking window instead of using chgwin
-- how I miss oil in this config.
-- annoying.

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4
vim.g.netrw_altfile = 1

vim.keymap.set("n", "<leader>n", ":Lexplore<cr>", { silent = true })
