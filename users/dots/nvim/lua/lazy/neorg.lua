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
        ["core.journal"] = { config = { workspace = "journal" } },
      },
    })
    vim.opt.conceallevel = 2
  end,
}
