{
  fetchurl,
  scripts,
  runCommandLocal,
}:
runCommandLocal "kokomi.jpg" {
  nativeBuildInputs = [scripts.wallcrop];
  src = fetchurl {
    url = "https://cdn.donmai.us/original/1a/2b/__sangonomiya_kokomi_genshin_impact_drawn_by_kiwiteamlp__1a2bd680aa1423cd74c769cf3f04f683.jpg";
    hash = "sha256-swwgPlD0HjN9v+ukzd5Dqf46bftsJ5Srzf5ljjgPoHI=";
  };
  dontUnpack = true;
}
''
  wallcrop $src 0 145 > $out
''
