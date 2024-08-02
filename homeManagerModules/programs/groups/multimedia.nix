{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    packageGroup = {
      multimedia.enable = lib.mkEnableOption "Enable Multimedia";
    };
  };

  config = lib.mkIf config.packageGroup.multimedia.enable {
    home.packages = with pkgs; [
      kdePackages.kdenlive
      losslesscut-bin
      transmission_4-qt6
      firefox
    ];
  };
}
