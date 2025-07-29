{
  lib,
  callPackage,
}:
lib.makeExtensible (final: {
  wallcrop = callPackage ./wallcrop.nix {};
  cowask = callPackage ./cowask.nix {};
  writeAwk = callPackage ./writeAwk.nix {};
  writeAwkBin = name: final.writeAwkScript "/bin/${name}";
  writeJQ = callPackage ./writeJQ.nix {};
  writeJQBin = name: final.writeJQ "/bin/${name}";
  gpurecording = callPackage ./gpurecording.nix {};
  kde-send = callPackage ./kde-send.nix {};
  npins-show = callPackage ./npins-show.nix {inherit (final) writeAwk;};
  legumulaunch = callPackage ./legumulaunch.nix {inherit (final) writeJQ;};
})
