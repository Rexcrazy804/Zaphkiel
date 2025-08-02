# a very special overlay with the following purposes
# 1. serve as the entry point for for default.nix's (at the root of th repo)
#    for exporting packages in its packages attribute
# 2. serve as a plain ol overlay for use within my nixos configurations
#
# why did I have to do it this way?
# SPEEEEED, if I had just done a (final: prev: self.packages.packages final)
# it'd be clean BUT AT THE COST OF 1.1-1.5 seconds of eval time!!!
#
# NOTE TO SELF
# don't add stuff to this unless for the following reasons
# 1. package depends on sources
# 2. package must be exported
#
# EVERYTHING ELSE GOES IN INTERNAL.NIX
# with <3 you from the past
# I will find you one day and bonk you
{
  quickshell ? null,
  sources,
  pkgs,
}: final: let
  inherit (final) callPackage;
in {
  quickshell =
    if (quickshell == null)
    then
      callPackage (sources.quickshell) {
        gitRev = sources.quickshell.revision;
        withJemalloc = true;
        withQtSvg = true;
        withWayland = true;
        withX11 = false;
        withPipewire = true;
        withPam = true;
        withHyprland = true;
        withI3 = false;
      }
    else quickshell;

  mpv-wrapped = callPackage ../mpv {};
  librebarcode = callPackage ../librebarcode.nix {};
  kokCursor = callPackage ../kokCursor.nix {};

  npins = callPackage (sources.npins + "/npins.nix") {};

  # WARNING
  # THIS WILL BUILD QUICKSHELL FROM SOURCE
  # you can find more information in the README
  kurukurubar-unstable = callPackage ../kurukurubar.nix {};
  # INFO
  # following zaphkiel master branch
  # quickshell v0.2.0 (nixpkgs)
  kurukurubar = (final.kurukurubar-unstable).override {
    inherit (pkgs) quickshell;
    # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
  };

  nixvim-minimal = import ../nvim.nix {
    inherit (sources) mnw;
    inherit pkgs;
  };
  nixvim = final.nixvim-minimal.override (prev: {
    extraBinPath =
      prev.extraBinPath
      ++ [
        # language servers
        pkgs.nil
        pkgs.lua-language-server
        pkgs.kdePackages.qtdeclarative
        # formatter
        pkgs.alejandra
      ];
  });

  # the booru image collection
  booru-images = let
    imgBuilder = callPackage (sources.booru-flake + "/nix/imgBuilder.nix");
  in (pkgs.lib.attrsets.mergeAttrsList (
    builtins.map (x: {${"i" + x.id} = imgBuilder x;}) (import ../../nixosModules/programs/booru-flake/imgList.nix)
  ));

  # some cute scripts
  scripts = callPackage ../scripts {};

  # is your boot secure yet?
  lanzaboote = import ../lanzaboote/default.nix {
    inherit (sources) nixpkgs rust-overlay crane lanzaboote;
  };

  # a lil cursed but lets me rexport the custom theme
  sddm-silent = callPackage (sources.silent-sddm) {gitRev = sources.silent-sddm.revision;};
  sddm-silent-custom = final.sddm-silent.override (import ../../nixosModules/programs/sddm/theme.nix {
    inherit (pkgs) fetchurl runCommandWith ffmpeg;
  });
}
