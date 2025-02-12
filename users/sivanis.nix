{pkgs, ...}: let
  username = "sivanis";
  description = "Sivani SV";
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.wrappedPkgs.nushell;
    isNormalUser = true;
    # extraGroups = ["networkmanager" "wheel" "multimedia"];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBlB7+ziR/1Wcvx/QvVGfI0x/84DjJQzgbUn0/SiGzyj sivani@hercomputer.com"
    ];
  };
}
