{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packages = {
      firefox.enable = lib.mkEnableOption "Enable firefox";
    };
  };

  config = lib.mkIf config.packages.firefox.enable {
    home.packages = [
      pkgs.firefoxpwa
    ];

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [
        pkgs.firefoxpwa
      ];
    };
  };
}
