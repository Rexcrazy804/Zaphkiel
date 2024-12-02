{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
    ./age.nix
  ];

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git wl-clipboard ripgrep p7zip unrar fd;
    nixvim = inputs.nixvim.packages.${pkgs.system}.default;
  };

  # wayland on electron and chromium based apps
  # disabled due to insanely slow startup time
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
