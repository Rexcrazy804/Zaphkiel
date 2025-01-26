{
  users,
  lib,
  config,
  ...
}: {
  options = {
    servModule.openssh = {
      enable = lib.mkEnableOption "Enable Openssh Service";
    };
  };

  config = lib.mkIf (config.servModule.openssh.enable && config.servModule.enable) {
    services.openssh = {
      enable = true;
      openFirewall = true;
      startWhenNeeded = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = users;
      };
    };
  };
}
