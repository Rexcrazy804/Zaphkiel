{
  lib,
  pkgs,
  config,
  options,
  sources,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.modules) importApply;
  inherit (lib.types) listOf str;
in {
  imports = [
    (importApply (sources.hjem + "/modules/nixos") {
      inherit pkgs config lib options;
      hjem-lib = import (sources.hjem + "/lib.nix") {inherit lib pkgs;};
    })
  ];

  options = {
    zaphkiel.data.users = mkOption {
      type = listOf str;
      default = [];
      description = "list of users (duh)";
    };
  };

  config.hjem.extraModules = [(sources.hjem-impure + "/hjem-impure.nix")];
}
