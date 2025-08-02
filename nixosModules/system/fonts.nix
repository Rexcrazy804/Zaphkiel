{
  pkgs,
  self,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (!config.zaphkiel.data.headless) {
    fonts = {
      fontDir.enable = true;
      packages = [
        pkgs.nerd-fonts.caskaydia-mono
        pkgs.nerd-fonts.caskaydia-cove
        pkgs.noto-fonts
        pkgs.noto-fonts-emoji
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-cjk-serif
        pkgs.material-symbols

        self.packages.librebarcode
      ];
    };
  };
}
