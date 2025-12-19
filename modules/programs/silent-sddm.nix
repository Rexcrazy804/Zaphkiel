{self, ...} @ inputs: {
  # NOTE
  # not really using this which is why the weird @inputs
  # to excape eval errors using laziness
  dandelion.modules.silent-sddm = {pkgs, ...}: {
    imports = [inputs.silent-sddm.nixosModules.default];
    programs.silentSDDM = {
      enable = true;
      theme = "rei";
      profileIcons.bob = self.packages.${pkgs.stdenv.hostPlatform.system}.images.voyager-profile;
      backgrounds = {
        reze = pkgs.fetchurl {
          name = "hana.jpg";
          url = "https://cdn.donmai.us/original/b8/a2/__reze_chainsaw_man_drawn_by_busuttt__b8a2fd187890a40b9d293dacbd6da2b0.jpg";
          hash = "sha256-xF/1Rx/x4BLaj0mA8rWa67cq/+K6NdkOcCAB7R11+M0=";
        };
        boring = "${pkgs.gnome-backgrounds}/share/backgrounds/gnome/symbolic-d.png";
      };
      settings = {
        "LoginScreen.LoginArea.Avatar" = {
          shape = "circle";
          active-border-color = "#ffcfce";
        };
        "LoginScreen" = {
          background = "hana.jpg";
        };
        "LockScreen" = {
          background = "hana.jpg";
        };
      };
    };
  };
}
