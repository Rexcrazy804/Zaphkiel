-- NOTE
-- This is a support file of sorts for using my dots outside NIX
-- i.e. linux systems without nix installed and Winblows.
--
-- For your convenience and my record here are the steps:
-- 1. clone repo
-- 2. copy dots/nvim into ~/.config/nvim/ (or equivalent in windows / osx)
-- 3. create init.lua at the root of the config with the following content:
--    ```lua
--    require('config')
--    require('mini')
--    ```

-- Mini installation
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd("echo \"Installing `mini.nvim`\" | redraw")
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd("echo \"Installed `mini.nvim`\" | redraw")
end
require("mini.deps").setup({ path = { package = path_package } })

-- Plugins (in nix, nix handles this the nix way :)
local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
now(function()
  add({ source = "lumen-oss/lz.n" })
  add({ source = "saghen/blink.cmp", checkout = "v1.8.0" })
  add({ source = "nvim-tree/nvim-web-devicons" })
  add({ source = "onsails/lspkind.nvim" })
  add({ source = "stevearc/oil.nvim" })

  -- opt
  add({ source = "nvim-lualine/lualine.nvim" })
  add({ source = "rose-pine/neovim" })
  add({ source = "ibhagwan/fzf-lua" })
  add({ source = "3rd/image.nvim" })
  add({ source = "folke/flash.nvim" })
  add({ source = "j-hui/fidget.nvim" })
  add({ source = "lukas-reineke/indent-blankline.nvim" })
  add({ source = "NotAShelf/direnv.nvim" })
  add({ source = "folke/which-key.nvim" })
  add({ source = "lewis6991/gitsigns.nvim" })
  add({ source = "windwp/nvim-autopairs" })
  add({ source = "nvim-treesitter/nvim-treesitter" })
end)

-- Invoke lz.n which handles rest of lazy loading
later(function()
  require("lz.n").load("plugins")
  vim.cmd.colorscheme("rose-pine")
end)
