{
  pkgs,
  config,
  lib,
  ...
}: let
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
    # wallpaper = config.programs.booru-flake.images."7655511";
    wallpaper = let
      image = config.programs.booru-flake.images."9561470";
    in
      pkgs.stdenv.mkDerivation {
        name = "cropped-${image.name}";
        src = image;
        dontUnpack = true;
        nativeBuildInputs = [pkgs.imagemagick];
        installPhase = ''
          # wallcrop $src 0 1030 > $out
          magick $src -crop 4368x2170+0+188 - > $out
        '';
      };
  };

  hjem.users."rexies".files = {
    ".config/hypr/hyprland.conf".text = let
      # override scaling for seraphine
      from = ["monitor = eDP-1, preferred, auto, 1.25"];
      to = ["monitor = eDP-1, preferred, auto, auto"];
    in
      lib.mkForce (builtins.replaceStrings from to (builtins.readFile ../../users/dots/hyprland/hyprland.conf));
  };
}
