{
  pkgs,
  config,
  lib,
  ...
}: let
  image = config.programs.booru-flake.images."9561470";
  wallpaper = pkgs.stdenv.mkDerivation {
    name = "cropped-${image.name}";
    src = image;
    dontUnpack = true;
    nativeBuildInputs = [pkgs.imagemagick];
    installPhase = ''
      # wallcrop $src 0 1030 > $out
      magick $src -crop 4368x2170+0+188 - > $out
    '';
  };
  packages = [
    pkgs.foot
    pkgs.cowsay
    pkgs.mpv-wrapped

    # internal overlay
    pkgs.discord
  ];
in {
  imports = [
    ../../nixosModules/external/matugen
    ./extras/filebrowser.nix
  ];
  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };
  programs.matugen = {
    enable = true;
    inherit wallpaper;
  };

  hjem.users."rexies".files = {
    # pin the fucking json so it doesn't get gc'd
    ".config/bg.json".source = image.raw_metadata;
    ".config/hypr/hyprland.conf".text = let
      # override scaling for seraphine
      from = ["monitor = eDP-1, preferred, auto, 1.25"];
      to = ["monitor = eDP-1, preferred, auto, auto"];
    in
      lib.mkForce (builtins.replaceStrings from to (builtins.readFile ../../users/dots/hyprland/hyprland.conf));
  };
}
