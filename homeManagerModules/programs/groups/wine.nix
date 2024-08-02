{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packageGroup = {
      wine.enable = lib.mkEnableOption "Enable Wine";
    };
  };

  config = lib.mkIf config.packageGroup.wine.enable {
    home.packages = with pkgs; [
      wineWowPackages.stable
      winetricks
      bottles
    ];
  };
}
