{pkgs, ...}: {
  neovim = pkgs.neovim-unwrapped;
  initLua = ''
    require("plugins")
    require("lz.n").load("lazy")
    vim.cmd.colorscheme "rose-pine"
  '';

  extraLuaPackages = p: [p.magick];
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
        ;

      treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
    };

    opt = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        image-nvim
        catppuccin-nvim
        rose-pine
        dracula-nvim
        neo-tree-nvim
        which-key-nvim
        toggleterm-nvim
        lualine-nvim
        nvim-colorizer-lua
        gitsigns-nvim
        flash-nvim
        fidget-nvim
        fzf-lua
        nvim-autopairs
        indent-blankline-nvim
        nvim-dbee
        ;
    };

    dev.myconfig = {
      pure = ../../users/dots/nvim;
      impure = "/home/rexies/nixos/users/dots/nvim";
    };
  };
}
