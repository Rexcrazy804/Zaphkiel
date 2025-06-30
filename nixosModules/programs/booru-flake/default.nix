{...}: {
  programs.booru-flake = {
    enable = true;
    prefetcher.enable = true;
    imgList = import ./imgList.nix;
    filters = {
      artists = {
        list = ["elodeas" "yoneyama_mai" "void_0" "morncolour"];
        invert = true;
      };
      previews.ratings = {
        list = ["e"];
      };
    };
  };
}
