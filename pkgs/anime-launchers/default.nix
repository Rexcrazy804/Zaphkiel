{
  extend,
  sources,
  kokoLib,
  craneLib,
}: let
  inherit (sources) rust-overlay aagl;
  inherit (pkgs.lib) makeScope;
  inherit (pkgs) newScope;

  pkgs = extend (import rust-overlay);
  rustToolchain = pkgs.rust-bin.stable.latest.default;
in
  makeScope newScope (self: let
    inherit (self) callPackage;
  in {
    inherit kokoLib;
    craneLib = craneLib.overrideToolchain rustToolchain;
    wrapAAGL = callPackage (aagl + "/pkgs/wrapAAGL/default.nix") {};
    sleepy-unwrapped = callPackage ./sleepy-unwrapped.nix {
      sleepySRC = sources.sleepy-launcher;
    };
    sleepy-launcher = callPackage (aagl + "/pkgs/sleepy-launcher") {
      unwrapped = self.sleepy-unwrapped;
    };
  })
