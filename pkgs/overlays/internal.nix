# this is very ugly and must be standardized in default.nix
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

  kurukurubar = final.kurukurubar-unstable.override {
    inherit (prev) quickshell;
    configPath = (sources.zaphkiel {pkgs = final;}) + "/users/dots/quickshell/kurukurubar";
  };

  kurukurubar-unstable = final.callPackage ../kurukurubar.nix {
    inherit (final) quickshell;
    inherit (final.scripts) gpurecording;
  };

  # example to use npins to for nvim plugins
  # vimPlugins = prev.vimPlugins.extend (final': prev': {
  #   flash-nvim = prev'.flash-nvim.overrideAttrs (_old: {
  #     src = (sources."flash.nvim" { pkgs = final; });
  #   });
  # });
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
        final.kdePackages.qtdeclarative
        # formatter
        final.alejandra
      ];
  });

  scripts = import ../scripts {inherit (final) lib callPackage;};
  mpv-wrapped = final.callPackage ../mpv {};
  sddm-silent = final.callPackage (sources.silent-sddm {pkgs = final;}) {gitRev = sources.silent-sddm.revision;};
  discord = prev.vesktop.override {withSystemVencord = true;};
  kokCursor = final.callPackage ../kokCursor.nix {};
  npins = final.callPackage (sources.npins {pkgs = final;} + "/npins.nix") {};

  # fonts
  librebarcode = final.callPackage ../librebarcode.nix {};
  gnomon = final.callPackage ../gnomon.nix {};

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

  # v6's the sources
  lanzaboote = import ../lanzaboote/default.nix (builtins.mapAttrs (k: v: v {pkgs = final;}) {
    inherit (sources) nixpkgs rust-overlay crane lanzaboote;
  });

  # a lil cursed but lets me rexport the custom theme
  sddm-silent-custom = final.sddm-silent.override (import ../../nixosModules/programs/sddm/theme.nix {
    inherit (final) fetchurl runCommandWith ffmpeg;
  });

  # nix build github:Rexcrazy804/Zaphkiel#booru-images."i<imageid>"
  booru-images = let
    imgBuilder = final.callPackage ((sources.booru-flake {pkgs = final;}) + "/nix/imgBuilder.nix");
  in (final.lib.attrsets.mergeAttrsList (
    builtins.map (x: {${"i" + x.id} = imgBuilder x;}) (import ../../nixosModules/programs/booru-flake/imgList.nix)
  ));
}
