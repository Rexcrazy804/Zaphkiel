{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
    ./age.nix
    ./direnv.nix
    ./obs.nix
  ];

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git p7zip unrar;
    nixvim = pkgs.wrappedPkgs.nvim-wrapped;
  };

  # wayland on electron and chromium based apps
  # disabled due to insanely slow startup time
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
