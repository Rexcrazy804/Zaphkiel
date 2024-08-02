{pkgs, ...}: {
  home.packages = with pkgs; [
    kdePackages.filelight
    zenith-nvidia
    radeontop
    wl-clipboard
    ripgrep
    p7zip
    unrar

    (pkgs.catppuccin-kde.override {
      flavour = ["mocha"];
      accents = ["red"];
    })
  ];
}
