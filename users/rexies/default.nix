{
  pkgs,
  inputs,
  config,
  ...
}: let
  username = "rexies";
  description = "Rexiel Scarlet";
  hostname = config.networking.hostName;
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs username hostname;};
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      ${username} = import ../../modules/home {inherit username hostname;};
    };
  };
}
