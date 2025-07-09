{
  sources ? import ./npins,
  pkgs ?
    import sources.nixpkgs {
      overlays = [(import sources.rust-overlay)];
    },
}: let
  rust = pkgs.rust-bin.stable.latest.default.override {
    # required by rust_analyzer
    extensions = ["rust-src" "rust-analyzer"];
  };
in
  pkgs.mkShell.override (old: {
    # Using mold for faster successive compiles
    stdenv = pkgs.stdenvAdapters.useMoldLinker old.stdenv;
  }) {
    buildInputs = [rust];
  }
