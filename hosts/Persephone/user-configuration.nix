{
  pkgs,
  lib,
  config,
  ...
}: let
  packages = lib.attrValues {
    # wine
    inherit (pkgs.wineWowPackages) waylandFull;
    inherit (pkgs) legendary-heroic bottles winetricks mono umu-launcher;
    # terminal
    inherit (pkgs) foot remmina libsixel;
    # from internal overlay
    inherit (pkgs) discord mpv-wrapped;
    inherit (pkgs.scripts) wallcrop legumulaunch;
  };
in {
  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.matugen = {
    enable = true;
    wallpaper = config.programs.booru-flake.images."2768802";
    # wallpaper = let
    #   image = config.programs.booru-flake.images."6887138";
    # in
    #   pkgs.stdenv.mkDerivation {
    #     name = "cropped-${image.name}";
    #     src = image;
    #     dontUnpack = true;
    #     # nativeBuildInputs = [pkgs.scripts.wallcrop];
    #     nativeBuildInputs = [pkgs.imagemagick];
    #     installPhase = ''
    #       magick $src -crop 1920x1080+600+1200 - > $out
    #       # wallcrop $src 0 1030 > $out
    #     '';
    #   };
  };

  hjem.users."rexies".files = {
    ".face.icon".source = let
      image = config.programs.booru-flake.images."6885267";
      face = pkgs.stdenv.mkDerivation {
        name = "cropped-${image.name}";
        src = image;
        dontUnpack = true;
        nativeBuildInputs = [pkgs.imagemagick];
        installPhase = ''
          magick $src -crop 450x450+640+25 - > $out
        '';
      };
    in
      lib.mkForce face;
    # "Pictures/booru".source = config.programs.booru-flake.imageFolder;
  };
}
