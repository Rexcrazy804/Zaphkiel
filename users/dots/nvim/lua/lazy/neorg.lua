return {
  "neorg",
  cmd = "Neorg",
  ft = "norg",
  keys = {
    { "<leader>nt", "<CMD>Neorg toc left<CR>", desc = "Neorg Table of contents" },
  },
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
