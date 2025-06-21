{
  neovimUtils,
  vimUtils,
  lib,
  vimPlugins,
  wrapNeovimUnstable,
  neovim-unwrapped,
  pkgs,
  ...
}: let
  nvimConfig = neovimUtils.makeNeovimConfig {
    withPython3 = false;
    withRuby = false;
    withNodejs = false;

    customRC = ''
      :luafile ${./init.lua}
    '';

    plugins = builtins.attrValues {
      inherit
        (vimPlugins)
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
        nvim-dbee
        ;

      # dbee-cmp = vimUtils.buildVimPlugin rec {
      #   pname = "cmp-dbee";
      #   version = "unstable-${builtins.substring 0 6 src.rev}";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "MattiasMTS";
      #     repo = "cmp-dbee";
      #     rev = "1650f67b9bf43c029fc37570665ca895a33cdf5a";
      #     sha256 = "sha256-XxB4jQu9xAi/7XDcwsd0hGLSs74ysjg0N/uaTHjqByI=";
      #   };
      #   nvimSkipModules = ["cmp-dbee.source" "cmp-dbee.connection"];
      #   meta.homepage = "https://github.com/hrsh7th/cmp-buffer/";
      # };

      treesitter = vimPlugins.nvim-treesitter.withAllGrammars;

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

  nvim = wrapNeovimUnstable neovim-unwrapped nvimConfig;
  packages = [
    # language servers
    pkgs.nil
    pkgs.lua-language-server
    pkgs.vscode-langservers-extracted
    pkgs.sqls
    # formatter
    pkgs.alejandra

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
      --prefix PATH : ${lib.makeBinPath packages} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [pkgs.oracle-instantclient]}
    '';

    meta.mainProgram = "nvim";
  }
