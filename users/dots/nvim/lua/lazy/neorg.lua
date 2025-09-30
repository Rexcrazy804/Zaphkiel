return {
  "neorg",
  cmd = "Neorg",
  ft = "norg",
  keys = {
    {
      "<leader>nt",
      "<CMD>Neorg toc left<CR>",
      desc = "Neorg Table of contents",
    },
    {
      "<leader>nj",
      "<CMD>Neorg journal today<CR>",
      desc = "Neorg Journal Today",
    },
    {
      "<leader>nJ",
      "<CMD>Neorg journal toc update<CR>",
      desc = "Neorg Journal TOC",
    },
  },
  after = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.summary"] = {},
        ["core.concealer"] = {
          config = {
            init_open_folds = "always",
            icon_preset = "diamond",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Documents/Mine/Notes",
              oracle = "~/Everwinter/md/oracle/",
              journal = "~/Documents/Mine/Brain/",
            },
          },
        },
        ["core.journal"] = {
          config = {
            workspace = "journal",
            -- slightly altered default function for <dd>| <title>
            toc_format = function(entries)
              local months_text = {
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December",
              }
              -- Convert the entries into a certain format to be written
              local output = {}
              local current_year
              local current_month

              for _, entry in ipairs(entries) do
                local day_pad = ""
                -- hey if it was gonna be a fucking
                -- string in the first place why not pad it .w.
                if tonumber(entry[3]) < 10 then day_pad = "0" end

                -- Don't print the year and month if they haven't changed
                if not current_year or current_year < entry[1] then
                  current_year = entry[1]
                  current_month = nil
                  table.insert(output, "* " .. current_year)
                end
                if not current_month or current_month < entry[2] then
                  current_month = entry[2]
                  table.insert(output, "** " .. months_text[current_month])
                end

                -- Prints the file link
                table.insert(
                  output,
                  "   "
                    .. entry[4]
                    .. string.format("[%s| %s]", day_pad .. entry[3], entry[5])
                )
              end

              return output
            end,
          },
        },
      },
    })
    vim.opt.conceallevel = 2
  end,
}
