{
  inputs,
  config,
  users,
  ...
}: let
  hostname = config.networking.hostName;
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./Wrappers
    ]
    # refer ExtraSpecialArgs.users in flake.nix
    ++ builtins.map (username: ./${username}.nix) users;

  home-manager = {
    extraSpecialArgs = {inherit inputs hostname;};
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
