{
  inputs,
  mein,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) system;
  packages = lib.attrValues {
    # wine
    inherit (pkgs.wineWowPackages) waylandFull;
    inherit (pkgs.heroic-unwrapped) legendary;
    inherit (pkgs) bottles winetricks mono umu-launcher;
    # terminal
    inherit (pkgs) foot remmina libsixel;
    # from internal overlay
    inherit (mein.${system}) mpv-wrapped;
    inherit (mein.${system}.scripts) wallcrop legumulaunch;

    booru-hs = inputs.booru-hs.packages.${pkgs.system}.default;

    discord = pkgs.discord.override {withMoonlight = true;};
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

  zaphkiel = {
    data.wallpaper = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/96/f4/96f4257e8cdbc7dff2e0389c8adfeaab.jpg";
      hash = "sha256-Fcm/08qrcJ0Qr8XW3iHKsQ/zmduiXjqJs9e9MVa2eq0=";
    };
    programs.matugen.scheme = "scheme-fidelity";
  };

  hjem.users."rexies".files.".face.icon".source = pkgs.stdenvNoCC.mkDerivation {
    name = "face.jpg";
    nativeBuildInputs = [pkgs.imagemagick];
    src = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/e9/c3/e9c3dbb346bb4ea181c2ae8680551585.jpg";
      hash = "sha256-0RKzzRxW1mtqHutt+9aKzkC5KijIiVLQqW5IRFI/IWY=";
    };
    dontUnpack = true;
    installPhase = "
      magick $src -crop 640x640+2300+1580 $out
    ";
  };
}
