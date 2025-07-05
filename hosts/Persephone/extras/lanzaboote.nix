{
  pkgs,
  lib,
  ...
}: let
  # have to manually import sources to prevent infinite recursion
  sources = import ../../../npins;
  lanzaboote = import (sources.lanzaboote + "/default-npins.nix") {inherit sources;};
in {
  imports = [(sources.lanzaboote + "/nix/modules/lanzaboote.nix")];
  environment.systemPackages = [pkgs.sbctl];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    package = lanzaboote.tool;
  };
}
