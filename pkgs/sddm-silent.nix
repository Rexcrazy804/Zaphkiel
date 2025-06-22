{
  writeText,
  lib,
  npins ? import ../npins,
  stdenvNoCC,
  kdePackages,
  theme ? "default",
  theme-overrides ? {},
}:
stdenvNoCC.mkDerivation (final: {
  pname = "sddm-silent";
  version = "${builtins.substring 0 6 final.src.revision}";

  src = npins.SilentSDDM;

  dontWrapQtApps = true;
  propagatedBuildInputs = [kdePackages.qtsvg kdePackages.qtmultimedia kdePackages.qtvirtualkeyboard];

  installPhase = let
    basePath = "$out/share/sddm/themes/${final.pname}";
    baseConfigFile = "${final.src}/configs/${theme}.conf";
    overrides = lib.generators.toINI {} theme-overrides;
    finalConfig = (builtins.readFile baseConfigFile) + "\n" + overrides;
    finalConfigFile = writeText "${theme}.conf" finalConfig;
  in ''
    mkdir -p ${basePath}
    cp -r $src/* ${basePath}

    substituteInPlace ${basePath}/metadata.desktop \
      --replace-warn configs/default.conf configs/${theme}.conf

    chmod +rw ${basePath}/configs/${theme}.conf
    cp ${finalConfigFile} ${basePath}/configs/${theme}.conf
  '';
})
