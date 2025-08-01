{
  pkgs,
  lib,
  self,
  config,
  ...
}: let
  inherit (lib) mkIf mkForce mkEnableOption;
in {
  imports = [self.nixosModules.lanzaboote];
  options.zaphkiel.programs.lanzaboote.enable = mkEnableOption "lanzaboote";
  config = mkIf config.zaphkiel.programs.lanzaboote.enable {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      configurationLimit = 12;
    };
  };
}
