{
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    progModule.stylix.enable = lib.mkEnableOption "Enable Stylix Module";
  };

  config = lib.mkIf config.progModule.stylix.enable {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix.enable = true;
    stylix.homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };
  };
}
