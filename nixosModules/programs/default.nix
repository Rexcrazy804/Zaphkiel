{
  pkgs,
  mein,
  ...
}: {
  imports = [
    # unimported
    # ./gdm.nix
    # ./aagl.nix
    # ./lanzaboote.nix

    # opts
    ./compositor
    ./steam.nix
    ./wine.nix
    ./obs.nix
    ./keyd.nix
    ./firefox.nix
    ./kuruDM.nix
    ./privoxy.nix
    ./matugen.nix
    ./winboat.nix
    ./shpool.nix

    # auto
    ./fish.nix
    ./age.nix
    ./direnv.nix
  ];

  # global
  environment.systemPackages = [
    mein.${pkgs.system}.xvim.default
    pkgs.git
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
