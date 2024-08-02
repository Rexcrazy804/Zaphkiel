{
  username ? null,
  hostname ? null,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ./Users/${username}.nix
    ./Hosts/${hostname}.nix

    ./programs
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
