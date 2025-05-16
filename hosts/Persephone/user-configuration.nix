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
    wallpaper = config.programs.booru-flake.images."6147541";
    # wallpaper = let
    #   image = config.programs.booru-flake.images."6537693";
    # in
    #   pkgs.runCommandWith {
    #     name = "croped-${image.name}";
    #     derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
    #   } ''
    #     magick ${image} -crop 3038x5400+0+1000 -rotate 90 - > $out
    #   '';
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
