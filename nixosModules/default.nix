{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./nix
    ./system
    ./graphics
    ./programs
    ./server
    ./utils

    ./exported/kurukuruDM.nix
    ./external/matugen
  ];

  options = {
    # basically used across the tree to disable certain modules that are enabled by default
    # which are unecesary for the tree
    zaphkiel.data.headless = mkEnableOption "headless";
  };
}
