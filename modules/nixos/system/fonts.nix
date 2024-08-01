{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    packages = let
      caskydia = pkgs.nerdfonts.override {
        fonts = ["CascadiaMono" "CascadiaCode"];
      };

      noto = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    in
      [caskydia] ++ noto;
  };
}
