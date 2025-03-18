{
  pkgs,
  inputs,
  config,
  ...
}: let
  generic = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.rconc
    pkgs.foot
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
    # just wanted to test if this worked alright .w.
    # wallpaper = inputs.booru-flake.packages.${pkgs.system}."7fbb92e87a168f102576ff9621319cbf".image;
     wallpaper = ./linsha_123071255_cropped.png;
  };
}
