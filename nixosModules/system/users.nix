{
  lib,
  pkgs,
  sources,
  ...
} @ args: let
  inherit (lib) mkOption;
  inherit (lib.modules) importApply;
  inherit (lib.types) listOf str path;

  argsWith = attrs: args // attrs;
  hjem-lib = import (sources.hjem + "/lib.nix") {inherit lib pkgs;};
  hjemModule = importApply (sources.hjem + "/modules/nixos") (argsWith {inherit hjem-lib;});
in {
  imports = [hjemModule];

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
      extraModules = [(sources.hjem-impure + "/hjem-impure.nix")];
      linker = pkgs.smfh;
    };
  };
}
