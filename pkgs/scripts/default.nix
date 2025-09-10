{
  pkgs,
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  wallcrop = callPackage ./wallcrop.nix {};
  cowask = callPackage ./cowask.nix {};
  gpurecording = callPackage ./gpurecording.nix {};
  kde-send = callPackage ./kde-send.nix {};
  npins-show = callPackage ./npins-show.nix {};
  legumulaunch = callPackage ./legumulaunch.nix {};
  qmlcheck = callPackage ./qmlcheck.nix {};

  # functions
  # seperate them into lib later?
  writeAwk = callPackage ./writeAwk.nix {};
  writeAwkBin = name: self.writeAwkScript "/bin/${name}";
  writeJQ = callPackage ./writeJQ.nix {};
  writeJQBin = name: self.writeJQ "/bin/${name}";
})
