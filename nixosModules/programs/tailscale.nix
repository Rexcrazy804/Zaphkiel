{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.tailscale = {
      enable = lib.mkEnableOption "Enable Tailscale Service";
    };
  };

  config = lib.mkIf config.progModule.tailscale.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };

    services.resolved.enable = true;
  };
}
