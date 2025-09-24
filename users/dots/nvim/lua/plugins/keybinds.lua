local map = vim.keymap.set
local defaults = function(desc)
  return { noremap = true, silent = true, desc = desc }
end

map("n", "<Tab>", "<CMD>bnext<CR>", defaults("Cycle next buffer"))
map("n", "<S-Tab>", "<CMD>bprevious<CR>", defaults("Cycle prev buffer"))
map("n", "<leader>x", "<CMD>bdelete<CR>", defaults("Delete current buffer"))
map("n", "<leader>X", "<CMD>bdelete!<CR>",
  defaults("Force delete current buffer"))

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    map("n", "<leader>lf", "<cmd>lua vim.diagnostic.open_float()<CR>",
      defaults("Lsp: Diagnostics"))
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>",
      defaults("Lsp: Goto Definition"))
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>",
      defaults("Lsp: Goto Declaration"))
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>",
      defaults("Lsp: Goto References"))
    map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>",
      defaults("Lsp: Goto Implementation"))
    map("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>",
      defaults("Lsp: Type Definition"))
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", defaults("Lsp: Hover"))
    map("n", "<leader>cw", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>",
      defaults("Lsp: Workspace Symbol"))
    map("n", "<leader>ra", "<cmd>lua vim.lsp.buf.rename()<cr>",
      defaults("Lsp: Rename"))
    map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.references()<cr>",
      defaults("Lsp: References"))
    map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<cr>",
      defaults("Lsp: Run the lsp formatter"))
    map({ "n", "v" }, "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>",
      defaults("Lsp: Code Actions"))
  end,
})
