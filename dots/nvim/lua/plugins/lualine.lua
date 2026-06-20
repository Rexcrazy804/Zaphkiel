local M = {}

M.change_id = nil
M.desc = nil

-- cute lil function to get the jujutsu status
M.jj_status = function()
  local cwd, err = vim.uv.cwd()
  if err then return end
  local sysobj = vim.system({
    "jj",
    "log",
    "-r",
    "@",
    "--template",
    "change_id.short(8) ++ description.first_line()",
    "--no-graph",
    "--ignore-working-copy",
  }, { cwd = cwd }, function() M.status = "err" end)

  local result = sysobj:wait(100)
  local status = vim.trim(result.stdout)
  M.change_id = " " .. status:sub(1, 8)
  M.desc = status:sub(9, status:len())
end

M.init = function()
  vim.api.nvim_create_autocmd(
    { "BufEnter" },
    { pattern = "*", callback = function(_) M.jj_status() end }
  )
end

return {
  "lualine.nvim",
  event = "VimEnter",
  after = function()
    if vim.g.vscode then return end
    M.init()
    require("lualine").setup({
      sections = {
        lualine_b = { function() return M.change_id end, "diff", "diagnostics" },
      },
      tabline = {
        lualine_a = { { "buffers", symbols = { alternate_file = "" } } },
        lualine_c = { function() return M.desc end },
        lualine_x = {
          function()
            local status = require("direnv").statusline()
            if status ~= "" then return status .. " " end
            return status
          end,
        },
      },
      options = {
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        theme = "auto",
      },
    })
  end,
}
