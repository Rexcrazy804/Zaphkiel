{
  username ? throw "Username Required",
  hostname ? throw "Hostname Required",
  ...
}: {
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ./homeUsers/${username}/${hostname}.nix
    ./programs
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
