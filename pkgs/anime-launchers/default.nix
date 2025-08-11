{
  extend,
  crane,
  rust-overlay,
  aagl,
  anime-sources,
}: let
  pkgs = extend (import rust-overlay);
  inherit (pkgs.lib) makeScope;
  inherit (pkgs) newScope;

  rustToolchain = pkgs.rust-bin.stable.latest.default;
in
  makeScope newScope (self: let
    inherit (self) callPackage;
    craneLib' = callPackage (crane + "/lib") {};
  in {
    craneLib = craneLib'.overrideToolchain rustToolchain;
    wrapAAGL = callPackage (aagl + "/pkgs/wrapAAGL/default.nix") {};
    sleepy-unwrapped = callPackage ./sleepy-unwrapped.nix {
      sleepySRC = anime-sources.sleepy-launcher;
    };
    sleepy-launcher = callPackage (aagl + "/pkgs/sleepy-launcher") {
      unwrapped = self.sleepy-unwrapped;
    };
  })
