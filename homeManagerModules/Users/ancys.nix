{
  lib,
  pkgs,
  ...
}: {
  # entry point for tuning home manager options per user [lower priority than
  # system so mostly mkdefaults here]
  packages = {
    alacritty.enable = lib.mkDefault true;
  };

  home.packages = with pkgs; [
  ];

}
