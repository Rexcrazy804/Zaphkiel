{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    packages = let
      caskydia = with pkgs.nerd-fonts; [
        caskaydia-mono
        caskaydia-cove
      ];

      noto = with pkgs; [
        noto-fonts
        noto-fonts-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        material-symbols
      ];
    in
      caskydia ++ noto;
  };
}
