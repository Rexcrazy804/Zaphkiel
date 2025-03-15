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

    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };
}
