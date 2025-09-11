# NO LONGER IMPORTED
{inputs, ...}: {
  imports = [inputs.booru-flake.nixosModules.default];

  programs.booru-flake = {
    enable = true;
    prefetcher.enable = true;
    imgList = import ./imgList.nix;
    filters = {
      artists = {
        list = ["elodeas" "yoneyama_mai" "void_0" "morncolour" "yeurei"];
        invert = true;
      };
      previews = {
        ratings.list = ["e"];
        ids.list = [
          7303513
          6752896
        ];
      };
    };
  };
}
