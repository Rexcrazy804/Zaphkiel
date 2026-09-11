{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.flake-inputs) hjem;
in {
  imports = [hjem.nixosModules.default];
  hjem.linker = lib.mkForce pkgs.smfh;
}
