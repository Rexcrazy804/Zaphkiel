{
  mein,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) package;

  cfg = config.zaphkiel.programs.winboat;
in {
  options.zaphkiel.programs.winboat = {
    enable = mkEnableOption "WinBoat - Windows apps on Linux";
    package = mkOption {
      type = package;
      default = mein.${pkgs.system}.winboat;
      description = "WinBoat package to use";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;

    # hardcoded cause I am lazy,
    # TODO be unlazy
    users.users.rexies.extraGroups = ["docker"];

    environment.systemPackages = [
      cfg.package
      pkgs.freerdp3
      pkgs.docker-compose
    ];
  };
}
