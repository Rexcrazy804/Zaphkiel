{
  pkgs,
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
    hashedPasswordFile = config.age.secrets.rexiesPass.path;
  };

  # define secrets
  age.secrets.rexiesPass = {
    file = ../secrets/secret1.age;
    owner = username;
  };

  home-manager.users.${username} = import ../homeManagerModules {inherit username hostname;};
}
