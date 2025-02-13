{pkgs, ...}: let
  nvimConfig = pkgs.callPackage ./nvimConfig.nix {};
  nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped nvimConfig;
  paths = [
    nvim
    pkgs.nixd
    pkgs.lua-language-server
    pkgs.rust-analyzer
    pkgs.fzf
    pkgs.ripgrep
    pkgs.wl-clipboard
    pkgs.fd
    pkgs.alejandra
  ];

  # we don't have to wrap the PATH if installed on nixos I think
  nvimPathsOnly = pkgs.symlinkJoin {
    name = "nvim";
    inherit paths;
  };

  nvimWrapped = pkgs.symlinkJoin {
    name = "nvim";
    inherit paths;

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/nvim \
      --prefix PATH : "$out/bin"
    '';
  };
in {
  nvim = nvim;
  nvim-lsp = nvimPathsOnly;
  nvim-lsp-wrapped = nvimWrapped;
}
