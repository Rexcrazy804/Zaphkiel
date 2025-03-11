{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
    ./age.nix
    ./direnv.nix
    ./obs.nix
    ./hyprland
  ];

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git p7zip unrar;
    nixvim = pkgs.wrappedPkgs.nvim-wrapped;
  };
  environment.variables.EDITOR = "nvim";

  # wayland on electron and chromium based apps
  # disable if  slow startup time for the same
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
