{
  extend,
  sources,
}: let
  inherit (sources) rust-overlay crane lanzaboote;
  pkgs = extend (import rust-overlay);
  uefi-rust-stable = pkgs.rust-bin.fromRustupToolchainFile (lanzaboote + "/rust/uefi/rust-toolchain.toml");
  craneLib = (pkgs.callPackage (crane + "/lib") {}).overrideToolchain uefi-rust-stable;
  rustTarget = "${pkgs.stdenv.hostPlatform.qemuArch}-unknown-uefi";
  buildRustApp = pkgs.callPackage ./buildRustApp.nix {inherit craneLib;};

  stubCrane = buildRustApp {
    pname = "lanzaboote-stub";
    src = craneLib.cleanCargoSource (lanzaboote + "/rust/uefi");
    target = rustTarget;
    doCheck = false;
  };

  stub = stubCrane.package;

  toolCrane = buildRustApp {
    pname = "lzbt-systemd";
    src = lanzaboote + "/rust/tool";
    extraArgs = {
      TEST_SYSTEMD = pkgs.systemd;
      nativeCheckInputs = with pkgs; [
        binutils-unwrapped
        sbsigntool
      ];
    };
  };

  tool = toolCrane.package;

  wrappedTool =
    pkgs.runCommand "lzbt"
    {
      nativeBuildInputs = [pkgs.makeWrapper];
      meta.mainProgram = "lzbt";
    } ''
      mkdir -p $out/bin
      makeWrapper ${tool}/bin/lzbt-systemd $out/bin/lzbt \
        --set PATH ${pkgs.lib.makeBinPath [pkgs.binutils-unwrapped pkgs.sbsigntool]} \
        --set LANZABOOTE_STUB ${stub}/bin/lanzaboote_stub.efi
    '';
in {
  inherit stub;
  tool = wrappedTool;
}
