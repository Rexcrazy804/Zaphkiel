{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    packageGroup = {
      emulators.enable = lib.mkEnableOption "Enable Emulators";
    };
  };

  config = lib.mkIf config.packageGroup.emulators.enable {
    home.packages = with pkgs; [
      ryujinx
      cemu
    ];
  };
}
