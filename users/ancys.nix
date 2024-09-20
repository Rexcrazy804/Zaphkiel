{
  pkgs,
  config,
  ...
}: let
  username = "ancys";
  description = "Ancy Stanley";
  hostname = config.networking.hostName;
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager.users.${username} = import ../homeManagerModules {inherit username hostname;};
}
