{
  lib,
  sources,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in {
  imports = [(sources.hjem + "/modules/nixos")];

  options = {
    zaphkiel.data.users = mkOption {
      type = listOf str;
      default = [];
      description = "list of users (duh)";
    };
  };

  config.hjem.extraModules = [(sources.hjem-impure + "/hjem-impure.nix")];
}
