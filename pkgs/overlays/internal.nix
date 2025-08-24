# kinda duplicated but fuck it, cleaner this way
final: prev: let
  inherit (final) callPackage;
in {
  # purely internal
  discord = prev.discord.override {
    withMoonlight = true;
  };
  gnomon = callPackage ../gnomon.nix {};

  # kuru
  quickshell = callPackage ../quickshell.nix {quickshell = null;};
  kurukurubar-unstable = callPackage ../kurukurubar.nix {};
  kurukurubar = (final.kurukurubar-unstable).override {inherit (prev) quickshell;};

  # trivial
  mpv-wrapped = callPackage ../mpv {};
  librebarcode = callPackage ../librebarcode.nix {};
  kokCursor = callPackage ../kokCursor.nix {};
  npins = callPackage ../npins.nix {};
  stash = callPackage (final.sources.stash + "/nix/package.nix") {};

  # package sets
  lanzaboote = callPackage ../lanzaboote {};
  scripts = callPackage ../scripts {};
  anime-launchers = callPackage ../anime-launchers {};
  xvim = callPackage ../nvim {};

  # lib
  kokoLib = callPackage ../kokoLib {};
  craneLib = callPackage (final.sources.crane + "/lib") {};

  # extra stuff to refer to later

  # I would spank Quinz for telling me about rare
  # and how outdated it was in nixpkgs
  # rare = prev.rare.overrideAttrs (old: {
  #   inherit (sources.rare) version;
  #   src = final.applyPatches {
  #     name = "patched-rare-src";
  #     patches = [../patches/rare.patch];
  #     src = sources.rare {pkgs = final;};
  #   };
  #   propagatedBuildInputs =
  #     old.propagatedBuildInputs
  #     ++ [
  #       final.python3Packages.setuptools-scm
  #       final.python3Packages.vdf
  #       final.python3Packages.pyside6
  #     ];
  # });

  # example to use npins to for nvim plugins
  # vimPlugins = prev.vimPlugins.extend (final': prev': {
  #   flash-nvim = prev'.flash-nvim.overrideAttrs (_old: {
  #     src = (sources."flash.nvim" { pkgs = final; });
  #   });
  # });
}
