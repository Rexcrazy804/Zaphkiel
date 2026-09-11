{
  pkgs,
  config,
  ...
}: let
  inherit (config.flake.packages.${system}) xvim;

  system = config.host-system;
in {
  environment.systemPackages = [
    xvim.default
    pkgs.git
    pkgs.npins
    pkgs.jujutsu
  ];

  environment.variables.EDITOR = "nvim";
  environment.variables.MANPAGER = "nvim +Man!";
  # nano deez nutz
  programs.nano.enable = false;
}
