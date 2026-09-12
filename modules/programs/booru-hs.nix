{
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs) booru-hs;
in {
  environment.systemPackages = [
    booru-hs.packages.${system}.default
  ];
}
