{
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.packages.${system}) xvim;
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
