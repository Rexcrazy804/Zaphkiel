{pkgs, ...}: let
  generic = [
    pkgs.wineWowPackages.stable
    pkgs.bottles
    pkgs.winetricks
    pkgs.rconc
    pkgs.wrappedPkgs.wezterm
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
  users.users."rexies" = {
    packages = special ++ generic;
    extraGroups = ["video" "input"];
  };
}
