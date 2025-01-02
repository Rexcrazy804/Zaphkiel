{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Rexiel Scarlet";
    userEmail = "37258415+Rexcrazy804@users.noreply.github.com";
  };

  home.packages = with pkgs; [
    btop
    filelight
    plasma-panel-colorizer
  ];
}
