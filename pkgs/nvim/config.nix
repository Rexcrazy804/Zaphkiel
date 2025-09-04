{
  wrapper,
  pkgs,
}:
wrapper {
  neovim = pkgs.neovim-unwrapped;
  initLua = ''
    require("plugins")
  '';

  extraBinPath = [
    pkgs.fzf
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.fd
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
        catppuccin-nvim
        rose-pine
        nightfox-nvim
        neo-tree-nvim
        which-key-nvim
        toggleterm-nvim
        lualine-nvim
        nvim-colorizer-lua
        gitsigns-nvim
        flash-nvim
        fidget-nvim
        telescope-nvim
        telescope-fzf-native-nvim
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
