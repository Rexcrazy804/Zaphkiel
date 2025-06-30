{pkgs, ...}: {
  imports = [
    ./gdm.nix
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
    ./age.nix
    ./direnv.nix
    ./obs.nix
    ./keyd.nix
    ./firefox.nix
    ./hyprland.nix
    ./booru-flake

    # this is not an option
    # auto enables fish and overwrites bash
    ./fish.nix
  ];

  # global
  environment.systemPackages = [
    pkgs.git
    pkgs.p7zip
    pkgs.unrar
    pkgs.nixvim
    pkgs.npins
  ];

  # requried by gdm leaving it here since all my systems do use nushell
  environment.shells = ["/run/current-system/sw/bin/nu"];

  environment.variables.EDITOR = "nvim";
  environment.variables.MANPAGER = "nvim +Man!";
  # remove nano
  programs.nano.enable = false;

  # wayland on electron and chromium based apps
  # disable if slow startup time for the same
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
