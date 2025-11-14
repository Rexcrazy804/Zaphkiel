return {
  "lualine.nvim",
  event = "VimEnter",
  after = function()
    require("lualine").setup({
      tabline = {
        lualine_a = { { "buffers", symbols = { alternate_file = "" } } },
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
