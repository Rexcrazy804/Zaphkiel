{
  pkgs,
  lib,
  ...
}: let
  nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodejs = false;

    customRC = ''
      :luafile ${./init.lua}
    '';

    plugins = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        lz-n
        catppuccin-nvim
        rose-pine
        neo-tree-nvim
        nvim-web-devicons
        which-key-nvim
        toggleterm-nvim
        lualine-nvim
        nvim-colorizer-lua
        gitsigns-nvim
        flash-nvim
        vim-startuptime
        fidget-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-lspconfig
        nvim-lsputils
        nvim-autopairs
        indent-blankline-nvim
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lsp
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lsp-signature-help
        lspkind-nvim
        ;

      treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

      # figure this out later by comparing this with nvim-treesitter.builtGrammars
      # treesitter = vimPlugins.nvim-treesitter.withPlugins (p: with p; [
      #   rust yaml xml vim
      #   typescript toml sql
      #   readline python php nix
      #   ninja meson lua luadoc
      #   latex kotlin json5 json
      #   javascript java ini hyprlang
      #   http html groovy go
      #   glsl gitignore gitcommit gitattributes
      #   git_rebase git_config gdscript diff
      #   dart cuda csv css
      #   cpp cmake c_sharp
      #   c bibtex bash awk
      #   nu
      # ]);
    };
  };

  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig;
  packages = [
    pkgs.nil
    pkgs.alejandra
    pkgs.lua-language-server

    pkgs.fzf
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.fd
  ];
in
  pkgs.symlinkJoin {
    name = "nvim-wrapped-${nvim.version}";

    paths = [nvim];

    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath packages}
    '';

    meta.mainProgram = "nvim";
  }
