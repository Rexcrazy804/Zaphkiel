# for use with CraneLib
# ensures that we don't rebuild the whole fucking thing
# if the package version changes
{runCommandNoCCLocal}: {
  self,
  pname ? self.pname,
  version ? self.version,
  src ? self.src,
  craneLib,
}: let
  inherit (craneLib) mkDummySrc cleanCargoSource;
  rgxIn = ''
    name = "${pname}"
    version = "${version}"
  '';
  rgxOut = ''
    name = "bakaPackage"
    version = "0.9.6"
  '';
in
  mkDummySrc {
    src = runCommandNoCCLocal "bakaSrc" {} ''
      cp -r ${cleanCargoSource src} $out
      substituteInPlace $out/Cargo.toml \
         --replace-fail '${rgxIn}' '${rgxOut}'
      substituteInPlace $out/Cargo.lock \
         --replace-fail '${rgxIn}' '${rgxOut}'
    '';
  }
