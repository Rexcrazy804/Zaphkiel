{config, ...}: let
  username = "rexies";
in {
    home.username = username;
    home.homeDirectory = "/home/${username}";

  imports = [
   ./programs
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
