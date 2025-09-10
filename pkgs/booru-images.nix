{
  lib,
  imgBuilder,
}: let
  imgList = import ../nixosModules/programs/booru-flake/imgList.nix;
in
  lib.foldl (acc: curr: acc // {"i${curr.id}" = imgBuilder curr;}) {} imgList
