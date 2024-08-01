{
  pkgs,
  inputs,
  config,
  ...
}: let
  username = "rexies";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${username} = {
    shell = pkgs.nushell;
    isNormalUser = true;
    description = "Rexiel Scarlet";
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../modules/home;
  };
}
