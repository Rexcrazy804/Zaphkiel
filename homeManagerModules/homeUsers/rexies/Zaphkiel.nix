{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    kdePackages.filelight
    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];
}
