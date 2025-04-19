{
  pkgs,
  inputs,
  config,
  lib,
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

  hjem.users."rexies".files = {
    ".config/hypr/hyprland.conf".text = let
      # override scaling for seraphine
      from = ["monitor = eDP-1, preferred, auto, 1.25"];
      to = ["monitor = eDP-1, preferred, auto, auto"];
    in
      builtins.replaceStrings from to (builtins.readFile ../../users/Configs/hyprland/hyprland.conf);
    ".config/hypr/hyprland.conf".source = lib.mkForce null;
  };
}
