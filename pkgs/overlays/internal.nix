{sources ? import ./npins}: final: prev: {
  quickshell = final.callPackage (sources.quickshell {pkgs = final;}) {
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
  kurukurubar = final.callPackage ../kurukurubar.nix {inherit (prev) quickshell;};
  kokCursor = final.callPackage ../kokCursor.nix {};
  nixvim-minimal = import ../nvim.nix {
    inherit (sources) mnw;
    pkgs = final;
  };
  nixvim = final.nixvim-minimal.override (prev: {
    extraBinPath =
      prev.extraBinPath
      ++ [
        # language servers
        final.nil
        final.lua-language-server
        # formatter
        final.alejandra
      ];
  });
  mpv-wrapped = final.callPackage ../mpv {};
  sddm-silent = final.callPackage (sources.silent-sddm {pkgs = final;}) {gitRev = sources.silent-sddm.revision;};
  wallcrop = final.callPackage ../wallcrop.nix {};
  scripts = final.callPackage ../scripts {};

  # a lil cursed but lets me rexport the custom theme
  sddm-silent-custom = final.sddm-silent.override (import ../../nixosModules/programs/sddm/theme.nix {
    inherit (final) fetchurl runCommandWith ffmpeg;
  });
}
