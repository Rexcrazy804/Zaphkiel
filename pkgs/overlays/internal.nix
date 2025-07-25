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

  # WARNING
  # THIS WILL BUILD QUICKSHELL FROM SOURCE
  # .override the quickshell attribute if you use the quickshell flake,
  # otherwise leave this be
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
  wallcrop = final.callPackage ../wallcrop.nix {};
  discord = prev.vesktop.override {withSystemVencord = true;};
  kokCursor = final.callPackage ../kokCursor.nix {};
  lanzaboote-tool = (import (sources.lanzaboote {pkgs = final;} + "/default-npins.nix") {inherit sources;}).packages.tool;
  npins = final.callPackage (sources.npins {pkgs = final;} + "/npins.nix") {};

  # fonts
  librebarcode = final.callPackage ../librebarcode.nix {};
  gnomon = final.callPackage ../gnomon.nix {};

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
