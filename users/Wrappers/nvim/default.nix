{
  pkgs,
  lib,
  ...
}: let
  nvimConfig = pkgs.callPackage ./nvimConfig.nix {};
  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig;
  packages = [
    pkgs.nixd
    pkgs.lua-language-server
    pkgs.rust-analyzer
    pkgs.fzf
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.fd
    pkgs.alejandra
    pkgs.vscode-langservers-extracted
    pkgs.taplo-lsp
  ];

  nvimWrapped = pkgs.symlinkJoin {
    name = "nvim-wrapped-${nvim.version}";

    paths = [
      nvim
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath packages}
    '';

    meta.mainProgram = "nvim";
  };
in {
  nvim-no-lsp = nvim;
  nvim-wrapped = nvimWrapped;
}
