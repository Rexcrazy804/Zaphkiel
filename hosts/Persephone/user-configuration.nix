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
    pkgs.wrappedPkgs.mpv
  ];
  special = builtins.attrValues {
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
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
    # wallpaper = config.programs.booru-flake.images."7089622";
    wallpaper = let
      image = config.programs.booru-flake.images."7240127";
    in
      pkgs.runCommandWith {
        name = "croped-${image.name}";
        derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
      } ''
        magick ${image} -crop 2058x1152+0+0 - > $out
      '';
  };

  hjem.users."rexies".files = {
    ".face.icon".source = let
      image = config.programs.booru-flake.images."2031742";
    in
      lib.mkForce (pkgs.runCommandWith {
          name = "croped-${image.name}";
          derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
        } ''
          magick ${image} -crop 420x420+880+100 - > $out
        '');
    "Pictures/booru".source = config.programs.booru-flake.imageFolder;
  };
}
