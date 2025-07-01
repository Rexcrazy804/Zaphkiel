{
  lib,
  callPackage,
}:
lib.makeExtensible (final: {
  wallcrop = callPackage ./wallcrop.nix {};
  cowask = callPackage ./cowask.nix {};
  gpurecording = callPackage ./gpurecording.nix {};
  kde-send = callPackage ./kde-send.nix {};
})
