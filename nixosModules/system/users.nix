{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str path;
in {
  imports = [inputs.hjem.nixosModules.default];

  options = {
    zaphkiel = {
      data.users = mkOption {
        type = listOf str;
        default = [];
        description = "list of users (duh)";
      };
      data.wallpaper = mkOption {
        type = path;
        description = "wallpaper path (duh)";
      };
    };
  };

  config = {
    hjem = {
      extraModules = [
        inputs.hjem-impure.hjemModules.default
        ../../users/hjemModules/games.nix
      ];
      linker = pkgs.smfh;
    };
  };
}
