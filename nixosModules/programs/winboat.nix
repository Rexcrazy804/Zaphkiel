{
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
      default = pkgs.winboat;
      description = "WinBoat package to use";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = [cfg.package];
    users.users.rexies.extraGroups = ["docker"];
  };
}
