{
  pkgs,
  lib,
  sources,
  config,
  ...
}: let
  lanzaboote = import (sources.lanzaboote + "/default-npins.nix") {
    sources = null;
    # default-npins.nix does not assume v6 so explicitly pass in my v6'd sources
    # so we can leverage it. not required otherwise
    inherit (sources) crane nixpkgs rust-overlay;
  };
in {
  imports = [lanzaboote.nixosModules.lanzaboote];
  options.zaphkiel.programs.lanzaboote.enable = lib.mkEnableOption "lanzaboote";
  config = lib.mkIf config.zaphkiel.programs.lanzaboote.enable {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # WARNING
      # this is from the internal overlay NOT THE SAME as pkgs.lanzaboote-tool
      # in nipxkgs which does NOT contain the required uefi stub
      # package = pkgs.lanzaboote-tool;
      configurationLimit = 12;
    };
  };
}
