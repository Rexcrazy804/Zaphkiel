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
    # packages = builtins.attrValues {
    #   # zen = pkgs.callPackage ../pkgs/zen-browser.nix {};
    # };
  };

  home-manager.users.${username} = import ../homeManagerModules {inherit username hostname;};
}
