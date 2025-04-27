{
lib,
config,
pkgs,
...
}: {
  options = {
    progModule.firefox.enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf config.progModule.firefox.enable {
    environment.systemPackages = [pkgs.firefoxpwa];
    programs.firefox = {
      enable = true;
      nativeMessagingHosts.packages = [
        pkgs.firefoxpwa
      ];
    };

    services.psd.enable = true;
    security.sudo.extraConfig = ''
      rexies ALL=(ALL) NOPASSWD: ${pkgs.profile-sync-daemon}/bin/psd-overlay-helper
    '';
  };
}
