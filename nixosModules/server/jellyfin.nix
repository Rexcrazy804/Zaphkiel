{
  users,
  lib,
  config,
  ...
}: {
  options = {
    servModule.jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin and related Services";
    };
  };

  config = lib.mkIf (config.servModule.jellyfin.enable && config.servModule.enable) {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    users.groups."multimedia".members = [
      "root"
      "jellyfin"
    ] ++ users;
  };
}
