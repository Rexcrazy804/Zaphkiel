-- vim options
vim.o.number = true
vim.o.termguicolors = true
-- vim.o.cmdheight = 0
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.signcolumn = "yes"

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.wrap = false

vim.o.scrolloff = 5

vim.g.mapleader = " ";

-- inline hints .w.
vim.diagnostic.config({ virtual_text = true })
-- plugins
require("lz.n").load {
  {
    "catppuccin-nvim",
    colorscheme = {
      "catppuccin",
      "catppuccin-frappe",
      "catppuccin-latte",
      "catppuccin-macchiato",
      "catppuccin-mocha",
    },
    after = function()
      require('catppuccin').setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = false,
      })
    end
  },

  {
    "rose-pine",
    colorscheme = {
      "rose-pine",
      "rose-pine-dawn",
      "rose-pine-main",
      "rose-pine-moon",
    },
    after = function()
      require("rose-pine").setup({
        variant = "auto",      -- auto, main, moon, or dawn
        dark_variant = "main", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true,        -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },

        highlight_groups = {
          -- leafy search
          CurSearch = { fg = "base", bg = "leaf", inherit = false },
          Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
        },
      })
    end
  },

  {
    "neo-tree.nvim",
    keys = {
      { "<C-n>", "<CMD>Neotree toggle<CR>", desc = "NeoTree toggle" },
    },
    after = function()
      require("neo-tree").setup()
    end,
  },

  {
    "which-key.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("which-key").setup({
        preset = "modern",
      })
    end,
  },

  {
    "toggleterm.nvim",
    keys = {
      { "<A-i>", "<CMD>ToggleTerm direction=float<CR>", desc = "Floating Term" },
    },
    after = function()
      require("toggleterm").setup({
        autochdir = true,
        highlights = require("rose-pine.plugins.toggleterm"),
        shade_terminals = true,
        direction = 'float',
        open_mapping = [[<A-i>]],
      })
    end,
  },

  {
    "nvim-colorizer",
    ft = {
      "lua",
      "css",
      "scss",
      "html",
      "ini",
      "toml",
      "json",
    },
    after = function()
      require("colorizer").setup()
    end,
  },

  {
    "lualine.nvim",
    event = "VimEnter",
    after = function()
      require("lualine").setup({
        tabline = {
          lualine_a = {
            { 'buffers', symbols = { alternate_file = '' } }
          },
        },
        options = {
          globalstatus = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          theme = "auto",
        }
      })
    end,
  },

  {
    "nvim-treesitter",
    event = "FileType",
    after = function()
      require('nvim-treesitter.configs').setup({
        sync_install = false,
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = false,
            node_decremental = "<A-CR>",
            node_incremental = "<CR>",
            -- scope_incremental = "grc",
          },
        },
        indent = {
          enable = true,
        },
      })
      -- don't fold by default .w. -- AL:KSDJ ASJDKL: AJSDKL: FUCK THIS FOLDING MOTHERFUCAKJL
      -- MADE FUCKING TOGGLE TERM SO SLOW THAT I WANTED TO KMS <ASDJ ASJDK AL>
      -- vim.opt.foldenable = false
      -- vim.wo.foldmethod = 'expr'
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
  },

  {
    "lspkind.nvim",
    dep_of = "nvim-cmp",
  },

  {
    "nvim-cmp",
    event = "InsertEnter",
    after = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
          }),
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.scroll_docs(-4),
          ['<C-j>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp',                priority = 1000 },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'nvim_lsp_document_symbol' },
          { name = 'nvim_lsp_signature_help' },
          -- { name = 'treesitter' },
        }),
      })
    end,
  },

  {
    "nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = function(client, bufnr)
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

      local default_servers = { "r_language_server", "cssls", "html", "jsonls", "nushell", "taplo", "jdtls", "texlab"}
      for _, lsp in ipairs(default_servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      lspconfig["lua_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        on_init = function(client)
          local library = {}

          -- don't waste time loading vim stuff if I am not in the nixos
          -- configuration directory
          if vim.fn.getcwd():find("nixos") then
            library[#library+1] = vim.env.VIMRUNTIME
          end

          -- this is for getting LuaCats completions from devEnvs and is
          -- entirely custom basically read the env var [ string of ':'
          -- seperated paths] and tokenizes it using the gmatch function the
          -- regex matches every continuos sequence of characters that is not
          -- ':' and appends it to the library variable
          local catsLibs = os.getenv("LUACATS_LIB") or ""
          for lib in catsLibs:gmatch("([^:]+)") do
            library[#library+1] = lib
          end

          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = library,
            }
          })
        end,
        settings = { Lua = {} }
      })

      lspconfig["rust_analyzer"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = "clippy",
              invocationLocation = "workspace",
              features = "all",
              extraArgs = {
                "--",
                "--no-deps",
                "-Dclippy::correctness",
                "-Dclippy::complexity",
                "-Wclippy::perf",
                "-Wclippy::pedantic",
              }
            },
            diagnostics = { styleLints = { enable = true } },
            rustfmt = { rangeFormatting = { enable = true } },
          }
        }
      })

      local file = io.open('/etc/hostname', 'r')
      local hostname = file:read("*line")
      -- only really works if I am the owner, should figure something out later
      local expr = string.format('(builtins.getFlake "git+file:///home/rexies/nixos").nixosConfigurations.%s.options',
        hostname)

      lspconfig["nil_ls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,

        settings = {
          ["nil"] = {
            formatting = {
              command = { "alejandra" },
            },
          },
        },
      })

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
    end,
  },

  {
    "indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      require("ibl").setup({
        scope = {
          show_end = false,
          show_exact_scope = false,
          show_start = false,
        },
      })
    end,
  },

  {
    "nvim-autopairs",
    event = "InsertEnter",
    after = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "gitsigns.nvim",
    event = "BufAdd",
    after = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']h', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']h', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end, { desc = "Gitsigns: next hunk" })

          map('n', '[h', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[h', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end, { desc = "Gitsigns: prev hunk" })

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "Gitsigns: stage hunk" })
          map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = "Gitsigns: unstage hunk" })
          map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "Gitsigns: reset hunk" })

          map('v', '<leader>hs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)
          map('v', '<leader>hu', function()
            gitsigns.undo_stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end)

          map('n', '<leader>hS', gitsigns.stage_buffer, { desc = "Gitsigns: stage Buffer" })
          map('n', '<leader>hR', gitsigns.reset_buffer, { desc = "Gitsigns: reset Buffer" })

          -- diffs
          map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "Gitsigns: preview hunk" })
          map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "Gitsigns: inline hunk" })
        end
      })
    end,
  },

  {
    "flash.nvim",
    event = "BufReadPost",
    keys = {
      { "<leader>/", "<CMD>lua require('flash').jump()<CR>", desc = "FLASH jump" },
    },

    after = function()
      require("flash").setup({
        search = {
          mode = "fuzzy",
        },
        modes = {
          search = {
            enabled = true,
          },
        },
      })
    end,
  },

  {
    "telescope.nvim",
    keys = {
      { "<leader>ff",  "<CMD>Telescope find_files<CR>",            desc = "Find Files" },
      { "<leader>fb",  "<CMD>Telescope buffers<CR>",               desc = "Find Buffers" },
      { "<leader>fc",  "<CMD>Telescope command_history<CR>",       desc = "Find old commands" },
      { "<leader>fg",  "<CMD>Telescope git_commits<CR>",           desc = "Find git commits" },
      { "<leader>fj",  "<CMD>Telescope jumplist<CR>",              desc = "Find jumps" },
      { "<leader>fw",  "<CMD>Telescope live_grep<CR>",             desc = "Find within all Files" },
      { "<leader>fo",  "<CMD>Telescope oldfiles<CR>",              desc = "Find recently opened files" },
      { "<leader>fd",  "<CMD>Telescope diagnostics<CR>",           desc = "Find Lsp Diagnostics" },
      { "<leader>fls", "<CMD>Telescope lsp_document_symbols<CR>",  desc = "Find LSP document symbols" },
      { "<leader>flw", "<CMD>Telescope lsp_workspace_symbols<CR>", desc = "Find LSP workspace symbols" },
    },

    after = function()
      require("telescope").setup({
        defaults = {
          layout_config = { prompt_position = "top", },
          sorting_strategy = "ascending",
        },

        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          },
        },
      })
      require('telescope').load_extension('fzf')
    end,
  },

  {
    "telescope-fzf-native.nvim",
  },

  {
    "fidget.nvim",
    event = "LspAttach",
    after = function()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
          },
        },
      })
    end
  },

  {
    "vim-startuptime",
    commad = "StartupTime",
  },
}

-- color scheme
vim.cmd.colorscheme "rose-pine"

-- keybinds
local map = vim.keymap.set
local defaults = function(desc) return { noremap = true, silent = true, desc = desc, } end

map('n', '<Tab>', '<CMD>bnext<CR>', defaults("Cycle next buffer"))
map('n', '<S-Tab>', '<CMD>bprevious<CR>', defaults("Cycle prev buffer"))
map('n', '<leader>x', '<CMD>bdelete<CR>', defaults("Delete current buffer"))
map('n', '<leader>X', '<CMD>bdelete!<CR>', defaults("Force delete current buffer"))

-- extra filetypes
vim.filetype.add {
  -- extension = { rasi = 'rasi' },
  pattern = {
    -- ['.*/waybar/config'] = 'jsonc',
    -- ['.*/mako/config'] = 'dosini',
    -- ['.*/kitty/*.conf'] = 'bash',
    ['.*/hyprland/.*%.conf'] = 'hyprlang',
  },
}
