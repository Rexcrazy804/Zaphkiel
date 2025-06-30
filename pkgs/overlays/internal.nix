{sources ? import ./npins}: final: prev: {
  quickshell = final.callPackage sources.quickshell {
    gitRev = sources.quickshell.revision;
    withJemalloc = true;
    withQtSvg = true;
    withWayland = true;
    withX11 = false;
    withPipewire = true;
    withPam = true;
    withHyprland = true;
    withI3 = false;
  };
  # nixpkgs version of quickshell for liverunning only
  quickshell-nix = prev.quickshell;
  kokCursor = final.callPackage ../kokCursor.nix {};
  nixvim-minimal = final.callPackage ../nvim {};
  nixvim = final.nixvim-minimal.override {
    extraPkgs = [
      # language servers
      final.nil
      final.lua-language-server
      final.vscode-langservers-extracted
      final.sqls
      # formatter
      final.alejandra
    ];
  };
  mpv-wrapped = final.callPackage ../mpv {};
  sddm-silent = final.callPackage sources.silent-sddm {gitRev = sources.silent-sddm.revision;};
  wallcrop = final.callPackage ../wallcrop.nix {};
  scripts = final.callPackage ../scripts {};
}
