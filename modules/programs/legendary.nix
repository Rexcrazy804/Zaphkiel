{
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) scripts;
in {
  environment.systemPackages = [
    pkgs.legendary-gl
    scripts.legumulaunch
  ];
}
