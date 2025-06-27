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
  kokCursor = final.callPackage ./pkgs/kokCursor.nix {};
  nixvim = final.callPackage ./pkgs/nvim {};
  mpv-wrapped = final.callPackage ./pkgs/mpv {};
  catppuccin-bat = final.callPackage ./pkgs/catppuccin-bat.nix {};
  sddm-silent = final.callPackage sources.silent-sddm {gitRev = sources.silent-sddm.revision;};
}
