{
  lib,
  callPackage,
}:
lib.makeExtensible (final: {
  wallcrop = callPackage ./wallcrop.nix {};
  cowask = callPackage ./cowask.nix {};
  writeAwk = callPackage ./writeAwkScript.nix {};
  writeAwkBin = name: final.writeAwkScript "/bin/${name}";
  gpurecording = callPackage ./gpurecording.nix {};
  kde-send = callPackage ./kde-send.nix {};
  npins-show = callPackage ./npins-show.nix {inherit (final) writeAwk;};
})
