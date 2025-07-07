{
  pkgs,
  mnw,
}: let
  # just taking what I need from mnw, you don't need to do this
  wrapper-uncheckd = pkgs.callPackage (mnw + "/wrapper.nix") {};
  wrapper = module: let
    inherit (pkgs) lib;
    evaled = lib.evalModules {
      specialArgs = {
        inherit pkgs;
        modulesPath = mnw + "/modules";
      };
      modules = [
        (import (mnw + "/modules/options.nix") false)
        module
      ];
    };

    failedAssertions = map (x: x.message) (builtins.filter (x: !x.assertion) evaled.config.assertions);
    baseSystemAssertWarn =
      if failedAssertions != []
      then throw "\nFailed assertions:\n${lib.concatMapStrings (x: "- ${x}") failedAssertions}"
      else lib.showWarnings evaled.config.warnings;
  in
    wrapper-uncheckd (baseSystemAssertWarn evaled.config);
in
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
        pure = ../users/dots/nvim;
        impure = "/home/rexies/nixos/users/dots/nvim";
      };
    };
  }
