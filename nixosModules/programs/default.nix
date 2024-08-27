{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./steam.nix
    ./sddm.nix
  ];

  # generic
  programs = {
    partition-manager.enable = true;
    kdeconnect.enable = true;
    mosh.enable = true;
  };

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git;
    nixvim = inputs.nixvim.packages.${pkgs.system}.default;
  };

  # wayland on electron and chromium based apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
