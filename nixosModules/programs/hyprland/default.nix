{
  users,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkEnableOption mkOption literalExpression;
in {
  options = {
    progModule.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      users = mkOption {
        type = types.listOf types.string;
        default = users;
        example = literalExpression "[\"rexies\", \"sanoys\"]";
        description = "
          list of users to include hyprland dots for
        ";
      };
    };
  };

  config = let 
    cfg = config.progModule.hyprland;
    configuration = [(import ./moduleconf.nix pkgs)];
    veedu = builtins.map (user:
      import ../../../lib/veedu.nix {
        inherit pkgs;
        user = user;
        source = ./conf;
        destination = ".config/hypr/";
      });
  in lib.mkIf cfg.enable (lib.mkMerge (configuration ++ veedu users));
}
