{
  inputs,
  config,
  ...
}: let
  hostname = config.networking.hostName;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs hostname;};
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
