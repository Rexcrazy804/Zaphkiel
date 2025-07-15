{
  pkgs,
  lib,
  config,
  ...
}: let
  packages = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.foot
    pkgs.cbonsai
    pkgs.cowsay

    # from internal overlay
    pkgs.mpv-wrapped
    pkgs.scripts.wallcrop
    pkgs.discord # yes this is vesktop
  ];
in {
  imports = [../../nixosModules/external/matugen];

  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };

  programs.matugen = {
    enable = true;
    # wallpaper = config.programs.booru-flake.images."8827425";
    wallpaper = let
      image = config.programs.booru-flake.images."6887138";
    in
      pkgs.stdenv.mkDerivation {
        name = "cropped-${image.name}";
        src = image;
        dontUnpack = true;
        # nativeBuildInputs = [pkgs.scripts.wallcrop];
        nativeBuildInputs = [pkgs.imagemagick];
        installPhase = ''
          magick $src -crop 1920x1080+600+1200 - > $out
          # wallcrop $src 0 1030 > $out
        '';
      };
  };

  hjem.users."rexies".files = {
    ".face.icon".source = let
      image = config.programs.booru-flake.images."6885267";
      face = pkgs.stdenv.mkDerivation {
        name = "cropped-${image.name}";
        src = image;
        dontUnpack = true;
        nativeBuildInputs = [pkgs.imagemagick];
        installPhase = ''
          magick $src -crop 450x450+640+25 - > $out
        '';
      };
    in
      lib.mkForce face;
    "Pictures/booru".source = config.programs.booru-flake.imageFolder;
  };
}
