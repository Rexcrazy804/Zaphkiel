{
  mein,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) system;
  packages = lib.attrValues {
    # wine
    inherit (pkgs.wineWowPackages) waylandFull;
    inherit (pkgs) legendary-heroic bottles winetricks mono umu-launcher;
    # terminal
    inherit (pkgs) foot remmina libsixel;
    inherit (pkgs) discord;
    # from internal overlay
    inherit (mein.${system}) mpv-wrapped;
    inherit (mein.${system}.scripts) wallcrop legumulaunch;
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

  zaphkiel.data.wallpaper = config.programs.booru-flake.images."8718409";
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
