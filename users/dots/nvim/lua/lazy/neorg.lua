return {
  "neorg",
  cmd = "Neorg",
  ft = "norg",
  after = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Documents/Mine/Notes",
              oracle = "~/Everwinter/md/oracle/",
            },
          },
        },
      },
    }
  end,
}
