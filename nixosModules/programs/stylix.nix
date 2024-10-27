{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [ inputs.stylix.nixosModules.stylix ];
  options = {
    progModule.stylix.enable = lib.mkEnableOption "Enable Stylix Module";
  };

  config = lib.mkIf config.progModule.stylix.enable {
    # will needa enable this tree wide ig?
    # imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = {
      enable = true;
      # this is overwritten by homeManagerModules but I can't evaluate stylix without setting this
      image = lib.mkDefault ../../homeManagerModules/dots/__yoru_chainsaw_man_drawn_by_banechiii__b55e78c91ee67398c7222a3a1c4286cc.jpg;
      autoEnable = false;
      homeManagerIntegration = {
        autoImport = true;
        followSystem = false;
      };
    };
  };
}
