{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.immich = {
      enable = lib.mkEnableOption "Enable Immich Service";
    };
  };

  config = lib.mkIf config.progModule.immich.enable {
    services.immich = {
      enable = true;
      openFirewall = true;
    };

    users.users.immich.extraGroups = [ "video" "render" ];
  };
}
