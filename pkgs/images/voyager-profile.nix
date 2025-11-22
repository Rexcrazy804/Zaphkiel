{
  fetchurl,
  imagemagick,
  runCommandNoCCLocal,
}:
runCommandNoCCLocal "voyager-face.jpg" {
  nativeBuildInputs = [imagemagick];
  src = fetchurl {
    url = "https://cdn.donmai.us/original/e9/c3/e9c3dbb346bb4ea181c2ae8680551585.jpg";
    hash = "sha256-0RKzzRxW1mtqHutt+9aKzkC5KijIiVLQqW5IRFI/IWY=";
  };
  dontUnpack = true;
}
''
  magick $src -crop 640x640+2300+1580 $out
''
