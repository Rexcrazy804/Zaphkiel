{self, ...}: {
  dandelion.modules.fonts = {
    pkgs,
    lib,
    ...
  }: {
    fonts = {
      fontDir.enable = true;
      packages = lib.attrValues {
        inherit (pkgs.nerd-fonts) caskaydia-mono caskaydia-cove;
        inherit (pkgs) noto-fonts noto-fonts-color-emoji noto-fonts-cjk-sans;
        inherit (pkgs) noto-fonts-cjk-serif material-symbols iosevka;
        inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) librebarcode;
      };
    };
  };
}
