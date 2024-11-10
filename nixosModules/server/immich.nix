{
  lib,
  config,
  ...
}: {
  options = {
    servModule.immich = {
      enable = lib.mkEnableOption "Enable Immich Service";
    };
  };

  config = lib.mkIf (config.servModule.immich.enable && config.servModule.enable) {
    services.immich = {
      enable = true;
      openFirewall = true;
    };

    users.users.immich.extraGroups = [ "video" "render" ];
  };
}
