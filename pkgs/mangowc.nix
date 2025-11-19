# adapted from
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/sw/sway/package.nix
{
  lib,
  mangowc-unwrapped,
  makeWrapper,
  symlinkJoin,
  writeShellScriptBin,
  withBaseWrapper ? true,
  extraSessionCommands ? "",
  dbus,
  withGtkWrapper ? true,
  wrapGAppsHook3,
  gdk-pixbuf,
  glib,
  gtk3,
  extraOptions ? [], # E.g.: [ "--verbose" ]
  enableXWayland ? true,
  dbusSupport ? true,
}:
assert extraSessionCommands != "" -> withBaseWrapper; let
  inherit (builtins) replaceStrings;
  inherit (lib.lists) optional optionals;
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatMapStrings optionalString;

  mango = mangowc-unwrapped.overrideAttrs (_oa: {
    inherit enableXWayland;
  });
  baseWrapper = writeShellScriptBin mango.meta.mainProgram ''
    set -o errexit
    if [ ! "$_MANGO_WRAPPER_ALREADY_EXECUTED" ]; then
      export XDG_CURRENT_DESKTOP=${mango.meta.mainProgram}
      ${extraSessionCommands}
      export _MANGO_WRAPPER_ALREADY_EXECUTED=1
    fi
    if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
      export DBUS_SESSION_BUS_ADDRESS
      exec ${getExe mango} "$@"
    else
      exec ${optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${getExe mango} "$@"
    fi
  '';
in
  symlinkJoin {
    inherit (mango) meta version;

    pname = replaceStrings ["-unwrapped"] [""] mango.pname;

    paths = (optional withBaseWrapper baseWrapper) ++ [mango];
    dontWrapGApps = true;
    strictDeps = false;

    nativeBuildInputs = [makeWrapper] ++ (optional withGtkWrapper wrapGAppsHook3);

    buildInputs = optionals withGtkWrapper [
      gdk-pixbuf
      glib
      gtk3
    ];

    postBuild = ''
      ${optionalString withGtkWrapper "gappsWrapperArgsHook"}

      wrapProgram $out/bin/${mango.meta.mainProgram} \
        ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
        ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
    '';

    passthru = {
      inherit (mango.passthru) providedSessions;
      unwrapped = mangowc-unwrapped;
    };
  }
