{
  pkgs,
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
      image = lib.mkDefault ../../homeManagerModules/dots/__yoru_chainsaw_man_drawn_by_anhelo__63f47bb46d9695afbb08b2ecb7e07670.jpg;
      autoEnable = false;
      homeManagerIntegration = {
        autoImport = true;
        followSystem = true;
      };
      fonts = {
        sansSerif = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        monospace = {
          # repetative, make an overlay soon
          package =  pkgs.nerdfonts.override {
            fonts = ["CascadiaMono" "CascadiaCode"];
          };
          name = "CaskaydiaMono Nerd font";
        };
      };
      cursor = {
        package = pkgs.vimix-cursors;
        size = 16;
        name = "Vimix-Cursors";
      };
    };
  };
}
