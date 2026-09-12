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
    pkgs.heroic-unwrapped.legendary
    scripts.legumulaunch
  ];
}
