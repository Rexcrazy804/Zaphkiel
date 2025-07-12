{
  lib,
  config,
  ...
}: {
  options.zaphkiel.services.openssh.enable = lib.mkEnableOption "openssh service";
  config = lib.mkIf (config.zaphkiel.services.openssh.enable && config.zaphkiel.services.enable) {
    services.openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = config.zaphkiel.data.users;
      };
    };
  };
}
