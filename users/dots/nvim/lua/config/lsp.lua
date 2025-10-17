local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- adapted from
-- https://github.com/neovim/neovim/discussions/33978#discussioncomment-13385052
local servers = {}
local config_files = vim.api.nvim_get_runtime_file("lsp/*.lua", true)

for _, config_file in ipairs(config_files) do
  local name = config_file:match("([^/]*)%.lua$")

  if name and (name:len() > 0) then table.insert(servers, name) end
end
vim.lsp.enable(servers)
