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
    ./extras/filebrowser.nix
  ];
  users.users."rexies" = {
    packages = special ++ generic;
    extraGroups = ["video" "input"];
  };
  programs.matugen = {
    enable = true;
    wallpaper = inputs.booru-flake.packages.${pkgs.system}."7655511";
  };

  # for my viewing pleasure
  hjem.users."rexies".files."Pictures/booru".source = inputs.booru-flake.packages.${pkgs.system}.default;
}
