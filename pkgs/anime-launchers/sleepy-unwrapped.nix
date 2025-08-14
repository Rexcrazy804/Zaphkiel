# adapted from
# https://github.com/ezKEa/aagl-gtk-on-nix/blob/main/pkgs/sleepy-launcher/unwrapped.nix
{
  lib,
  pkg-config,
  cmake,
  openssl,
  glib,
  pango,
  gdk-pixbuf,
  gtk4,
  libadwaita,
  gobject-introspection,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  librsvg,
  customIcon ? null,
  craneLib,
  sleepySRC,
  kokoLib,
}: let
  inherit (lib) optionalString licenses;
  inherit (lib) cleanSourceWith cleanSource hasSuffix;
  inherit (craneLib) buildDepsOnly buildPackage;
  inherit (kokoLib) mkBakaSrc;

  commonArgs = {
    strictDeps = true;
    nativeBuildInputs = [cmake glib gobject-introspection gtk4 pkg-config wrapGAppsHook4];
    buildInputs = [gdk-pixbuf gsettings-desktop-schemas libadwaita librsvg openssl pango];
  };

  cargoArtifacts = buildDepsOnly {
    inherit (commonArgs) strictDeps nativeBuildInputs buildInputs;
    name = "${self.pname}-deps";
    dummySrc = mkBakaSrc {inherit self craneLib;};
  };

  self = buildPackage {
    inherit (commonArgs) strictDeps nativeBuildInputs buildInputs;
    inherit cargoArtifacts;
    src = cleanSourceWith {
      filter = fname: _ftype:
        !(
          hasSuffix ".nix" fname
          || hasSuffix ".md" fname
          || hasSuffix ".py" fname
          || hasSuffix "LICENSE" fname
        );
      src = cleanSource sleepySRC;
    };

    prePatch = optionalString (customIcon != null) ''
      rm assets/images/icon.png
      cp ${customIcon} assets/images/icon.png
    '';
    passthru = {inherit customIcon;};
    meta.license = licenses.gpl3;
  };
in
  self
