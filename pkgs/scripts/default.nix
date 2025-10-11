{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  wallcrop = callPackage ./wallcrop.nix {};
  changeWall = callPackage ./changeWall.nix {};
  cowask = callPackage ./cowask.nix {};
  gpurecording = callPackage ./gpurecording.nix {};
  npins-show = callPackage ./npins-show.nix {};
  legumulaunch = callPackage ./legumulaunch.nix {};
  qmlcheck = callPackage ./qmlcheck.nix {};
  taildrop = callPackage ./taildrop.nix {};

  # functions
  # seperate them into lib later?
  writeAwk = callPackage ./writeAwk.nix {};
  writeAwkBin = name: self.writeAwkScript "/bin/${name}";
  writeJQ = callPackage ./writeJQ.nix {};
  writeJQBin = name: self.writeJQ "/bin/${name}";
})
