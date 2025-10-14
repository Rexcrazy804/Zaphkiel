{pkgs, ...}: {
  neovim = pkgs.neovim-unwrapped;
  initLua = ''
    require("config")
    require("lz.n").load("plugins")
    vim.cmd.colorscheme "rose-pine"
  '';

  extraLuaPackages = p: [p.magick p.neorg];
  extraBinPath = [
    pkgs.fzf
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.fd
    pkgs.imagemagick
  ];

  plugins = {
    start = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        lz-n
        blink-cmp
        nvim-web-devicons
        lspkind-nvim
        oil-nvim
        ;

      treesitter = let
        nts = pkgs.vimPlugins.nvim-treesitter;
        tsg = pkgs.tree-sitter-grammars;
        norgG = [tsg.tree-sitter-norg tsg.tree-sitter-norg-meta];
      in
        nts.withPlugins (_: nts.allGrammars ++ norgG);
    };

    opt = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        image-nvim
        catppuccin-nvim
        rose-pine
        tokyonight-nvim
        neo-tree-nvim
        which-key-nvim
        toggleterm-nvim
        lualine-nvim
        gitsigns-nvim
        flash-nvim
        fidget-nvim
        fzf-lua
        nvim-autopairs
        indent-blankline-nvim
        neorg
        direnv-nvim
        ;
    };

    dev.myconfig = {
      pure = ../../users/dots/nvim;
      impure = "/home/rexies/nixos/users/dots/nvim";
    };
  };
}
