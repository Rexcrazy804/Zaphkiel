{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) librebarcode;
in {
  fonts = {
    fontDir.enable = true;
    packages = lib.attrValues {
      inherit (pkgs.nerd-fonts) caskaydia-mono caskaydia-cove;
      inherit (pkgs) noto-fonts noto-fonts-color-emoji noto-fonts-cjk-sans;
      inherit (pkgs) noto-fonts-cjk-serif material-symbols iosevka;
      inherit librebarcode;
    };
  };
}
