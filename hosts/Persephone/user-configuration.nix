{
  pkgs,
  lib,
  config,
  ...
}: let
  generic = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.foot
    pkgs.cbonsai
    pkgs.cowsay
    pkgs.mpv-wrapped
  ];
  special = builtins.attrValues {
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withMoonlight = true;
    };
  };
in {
  imports = [
    ../../nixosModules/external/matugen
    # ./extras/filebrowser.nix
  ];

  users.users."rexies" = {
    packages = special ++ generic;
    extraGroups = ["video" "input"];
  };

  programs.matugen = {
    enable = true;
    # wallpaper = config.programs.booru-flake.images."8827425";
    wallpaper = let
      image = config.programs.booru-flake.images."8718409";
    in
      pkgs.runCommandWith {
        name = "cropped-${image.name}";
        derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
      } ''
        magick ${image} -crop 4006x2253+0+50 - > $out
      '';

    # nushell code for some automation
    # preserving this here
    # magick identify $image
    # | split row " "
    # | get 2
    # | parse "{width}x{height}"
    # | [($in.width.0 | into int), (1080 * (($in.width.0 | into int) / 1920))]
    # | do {
    #   # print what should be copied to nix
    #   print $"magick ${image} -crop ($in.0)x($in.1 | math round)+0+50"
    #   magick $image -crop $"($in.0)x($in.1 | math round)+0+50" - | save -f ./output
    #   swww img ./output
    # }
  };

  hjem.users."rexies".files = {
    ".face.icon".source = let
      image = config.programs.booru-flake.images."8714169";
    in
      lib.mkForce (pkgs.runCommandWith {
          name = "cropped-${image.name}";
          derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
        } ''
          magick ${image} -crop 600x600+1220+100 - > $out
        '');
    "Pictures/booru".source = config.programs.booru-flake.imageFolder;
  };
}
