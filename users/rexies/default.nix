{
  pkgs,
  inputs,
  config,
  ...
}: let
  username = "rexies";
  description = "Rexiel Scarlet";
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../modules/home { inherit username; };
  };
}
