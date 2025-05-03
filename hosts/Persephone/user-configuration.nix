{
  pkgs,
  inputs,
  lib,
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
    wallpaper = inputs.booru-flake.packages.${pkgs.system}."2332312";
    # wallpaper = let
    #   image = inputs.booru-flake.packages.${pkgs.system}."8726475";
    # in
    #   pkgs.runCommandWith {
    #     name = "croped-${image.name}";
    #     derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
    #   } ''
    #     magick ${image} -crop 1253x705+0+100 - > $out
    #   '';
  };

  hjem.users."rexies".files.".face.icon".source = let
    image = inputs.booru-flake.packages.${pkgs.system}."2031742";
  in
    lib.mkForce (pkgs.runCommandWith {
      name = "croped-${image.name}";
      derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
    } ''
      magick ${image} -crop 420x420+880+100 - > $out
    '');
}
