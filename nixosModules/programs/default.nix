{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
  ];

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git wl-clipboard ripgrep p7zip unrar fd;
    nixvim = inputs.nixvim.packages.${pkgs.system}.default;
  };

  # wayland on electron and chromium based apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
