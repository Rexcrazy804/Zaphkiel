{
  pkgs,
  config,
  ...
}: let
  username = "sanoys";
  description = "Sanoy Simon";
  hostname = config.networking.hostName;
in {
  users.users.${username} = {
    inherit description;

    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };
}
