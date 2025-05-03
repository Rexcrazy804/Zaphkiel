{
  pkgs,
  inputs,
  config,
  ...
}: let
  packages = [
    pkgs.wineWowPackages.stable
    pkgs.foot
  ];
in {
  imports = [
    ../../nixosModules/external/matugen
  ];
  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };

  users.users."ancys" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };

  programs.matugen = {
    enable = true;
    wallpaper = ../Aphrodite/kokomi_116824847_p0_cropped.jpg;
  };
}
