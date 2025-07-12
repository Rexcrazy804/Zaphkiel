{
  lib,
  config,
  ...
}: {
  options.zaphkiel.services.immich.enable = lib.mkEnableOption "immich service";

  config = lib.mkIf (config.zaphkiel.services.immich.enable && config.zaphkiel.services.enable) {
    services.immich = {
      enable = true;
      openFirewall = true;
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
