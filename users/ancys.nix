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

    shell = pkgs.wrappedPkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };
}
