{
  lib,
  sources,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in {
  # refer ExtraSpecialArgs.users in flake.nix
  imports = [(sources.hjem + "/modules/nixos")];

  options = {
    zaphkiel.data.users = mkOption {
      type = listOf str;
      default = [];
      description = "list of users (duh)";
    };
  };
}
