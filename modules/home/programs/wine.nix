{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packages = {
      wine.enable = lib.mkEnableOption "Enable Wine";
    };
  };

  config = lib.mkIf config.packages.wine.enable {
    home.packages = with pkgs; [
      wineWowPackages.stable
      winetricks
      bottles
    ];
  };
}
