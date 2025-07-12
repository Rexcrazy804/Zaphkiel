{
  lib,
  config,
  pkgs,
  ...
}: {
  options.zaphkiel.programs.firefox.enable = lib.mkEnableOption "firefox";
  config = lib.mkIf config.zaphkiel.programs.firefox.enable {
    environment.systemPackages = [pkgs.firefoxpwa];
    programs.firefox = {
      enable = true;
      nativeMessagingHosts.packages = [
        pkgs.firefoxpwa
      ];
    };
  };
}
