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
      autoEnable = false;
      fonts.monospace = {
        # repetative, make an overlay soon
        package =  pkgs.nerdfonts.override {
          fonts = ["CascadiaMono" "CascadiaCode"];
        };
        name = "CaskaydiaMono Nerd font";
      };
      enable = true;
      image = ../dots/__yoru_chainsaw_man_drawn_by_banechiii__b55e78c91ee67398c7222a3a1c4286cc.jpg;
      polarity = "dark";

      targets = {
        bat.enable = true;
        firefox = { 
          enable = true; 
          profileNames = ["default"];
        };

        gnome.enable = true;
        gtk.enable = true;
        nixvim = {
          enable = true;
          transparentBackground = {
            main = true;
            signColumn = true;
          };
        };
        nushell.enable = true;
        sway.enable = true;
      };
    };
  };
}
