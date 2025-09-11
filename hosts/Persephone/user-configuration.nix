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

  zaphkiel.data.wallpaper = pkgs.fetchurl {
    url = "https://cdn.donmai.us/original/00/07/__herta_and_the_herta_honkai_and_1_more_drawn_by_meirong__0007dfbed6ffd22f36e9423b596b004b.jpg";
    hash = "sha256-Pc1sI1qd/N7OdnRXtPb3RqHMdxyI8NdiPY/7yPxx6ig=";
  };
}
