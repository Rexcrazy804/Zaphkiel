{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    packages = {
      stylix.enable = lib.mkEnableOption "Enable stylix";
    };
  };

  config = lib.mkIf config.packages.stylix.enable {
    warnings = [ "packages.stylix.enable REQUIRES progmodules.stylix to be enabled on host" ];
    stylix = {
      enable = lib.mkForce true;

      image = ../dots/__yoru_chainsaw_man_drawn_by_anhelo__63f47bb46d9695afbb08b2ecb7e07670.jpg;
      # polarity = "dark";

      targets = {
        bat.enable = true;
        # firefox = { 
        #   enable = true; 
        #   profileNames = ["default"];
        # };

        gnome.enable = true;
        gtk.enable = true;
        # nushell.enable = true;
        sway.enable = true;
      };
    };
  };
}
