{
  pkgs,
  config,
  ...
}: let
  username = "sivanis";
  description = "Sivani SV";
  hostname = config.networking.hostName;
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    # extraGroups = ["networkmanager" "wheel" "multimedia"];
    hashedPasswordFile = config.age.secrets.rexiesPass.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlB7+ziR/1Wcvx/QvVGfI0x/84DjJQzgbUn0/SiGzyj sivani@hercomputer.com"
    ];
  };

  home-manager.users.${username} = import ../homeManagerModules {inherit username hostname;};
}
