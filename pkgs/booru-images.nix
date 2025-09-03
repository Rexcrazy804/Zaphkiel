{
  lib,
  sources,
  callPackage,
}: let
  inherit (sources) booru-flake;
  imgBuilder = callPackage (booru-flake + "/nix/imgBuilder.nix");
  imgList = import ../nixosModules/programs/booru-flake/imgList.nix;
in
  lib.foldl (acc: curr: acc // {"i${curr.id}" = imgBuilder curr;}) {} imgList
