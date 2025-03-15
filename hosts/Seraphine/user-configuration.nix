{
  pkgs,
  config,
  ...
}: let
  generic = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.rconc
    pkgs.wrappedPkgs.foot
    pkgs.cbonsai
    pkgs.cowsay
  ];
  special = builtins.attrValues {
    mpv = pkgs.wrappedPkgs.mpv;

    discord = pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };
  };
in {
  imports = [
    ../../nixosModules/external/matugen
  ];
  users.users."rexies" = {
    packages = special ++ generic;
    extraGroups = ["video" "input"];
  };
  programs.matugen = {
    enable = true;
    wallpaper = ./linsha_123071255_cropped.png;
  };
}
