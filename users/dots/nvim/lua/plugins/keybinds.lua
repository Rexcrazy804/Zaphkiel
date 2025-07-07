local map = vim.keymap.set
local defaults = function(desc) return { noremap = true, silent = true, desc = desc, } end

map('n', '<Tab>', '<CMD>bnext<CR>', defaults("Cycle next buffer"))
map('n', '<S-Tab>', '<CMD>bprevious<CR>', defaults("Cycle prev buffer"))
map('n', '<leader>x', '<CMD>bdelete<CR>', defaults("Delete current buffer"))
map('n', '<leader>X', '<CMD>bdelete!<CR>', defaults("Force delete current buffer"))

-- lsp
vim.lsp.config("*", {
  on_attach = function(client, bufnr)
    local opts = function(desc)
      return { noremap = true, silent = true, desc = desc, }
    end
    local map = vim.api.nvim_buf_set_keymap
    map(bufnr, 'n', '<leader>lf', '<cmd>lua vim.diagnostic.open_float()<CR>', opts('Lsp: Diagnostics'))
    map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts('Lsp: Goto Definition'))
    map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts('Lsp: Goto Declaration'))
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts('Lsp: Goto References'))
    map(bufnr, 'n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts('Lsp: Goto Implementation'))
    map(bufnr, 'n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts('Lsp: Type Definition'))
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts('Lsp: Hover'))
    map(bufnr, 'n', '<leader>cw', '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts('Lsp: Workspace Symbol'))
    map(bufnr, 'n', '<leader>ra', '<cmd>lua vim.lsp.buf.rename()<cr>', opts('Lsp: Rename'))
    map(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.references()<cr>', opts('Lsp: References'))
    map(bufnr, 'n', '<leader>fm', '<cmd>lua vim.lsp.buf.format()<cr>', opts('Lsp: Run the lsp formatter'))
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', '<CMD>lua vim.lsp.buf.code_action()<CR>', opts('Lsp: Code Actions'))
  end
})
