{
  mein,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) system;
  packages = lib.attrValues {
    # wine
    inherit (pkgs.wineWowPackages) waylandFull;
    inherit (pkgs) legendary-heroic bottles winetricks mono umu-launcher;
    # terminal
    inherit (pkgs) foot remmina libsixel;
    # from internal overlay
    inherit (mein.${system}) mpv-wrapped;
    inherit (mein.${system}.scripts) wallcrop legumulaunch;

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

  zaphkiel.data.wallpaper = ./herta.jpg;
}
