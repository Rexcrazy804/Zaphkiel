{...}: {
  home.username = "rexies";
  home.homeDirectory = "/home/rexies";

  imports = [
    ./programs
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
