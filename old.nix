{
  pkgs,
  system,
  lib,
  inputs,
  sources,
  ...
}:
lib.fix (self: let
  inherit (lib) warn;
  inherit (pkgs) callPackage;
in {
  # NOTE
  # for fingerprint to work in kurukuruDM,
  # you will need quickshell v0.2.1 minimum
  kurukurubar-unstable = warn "kurukurubar-unstable depricated, use kurukurubar" self.kurukurubar;
  stash = inputs.stash.packages.${system}.default;
  xvim = callPackage ./nvim {
    mnw = inputs.mnw.lib;
    inherit sources;
  };
})
