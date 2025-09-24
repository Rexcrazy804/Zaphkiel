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

  zaphkiel.data.wallpaper = pkgs.fetchurl {
    url = "https://cdn.donmai.us/original/99/9d/999d4de94253b96e02bebae7fd8d8b53.jpg";
    hash = "sha256-vwtq6zGs4N4WlAT7nnfUyvA720CWOBdeQ1oV65XYaHs=";
  };

  hjem.users."rexies".files.".face.icon".source = pkgs.fetchurl {
    url = "https://cdn.donmai.us/original/4e/62/4e62c63e4ee802f41ebb9e4074716758.jpg";
    hash = "sha256-JNdDjK9U9VB1m23OKzqnx/GKlqnMgqOTVcMvMfm5WR4=";
  };
}
