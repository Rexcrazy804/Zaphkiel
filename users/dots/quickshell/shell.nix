# NOTE
# typically you don't want your devShells to depend on the version of your config's nixpkgs
# but since I want the quickshell version to be consistent between system and the shell
# this shell imports the config's npins.
{
  sources ? import ../../../npins,
  pkgs ?
    import sources.nixpkgs {
      overlays = [(import ../../../pkgs/overlays/internal.nix {inherit sources;})];
    },
}: let
  inherit (pkgs) quickshell material-symbols google-fonts rembg;
  inherit (pkgs.lib) makeSearchPath;
  inherit (pkgs.kdePackages) qtbase qtdeclarative;

  qtDeps = [quickshell qtbase qtdeclarative];
  qmlPath = makeSearchPath "lib/qt-6/qml" qtDeps;
in
  pkgs.mkShell {
    shellHook = ''
      export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${qmlPath}"
    '';
    buildInputs = qtDeps ++ [rembg];
    packages = [material-symbols google-fonts];
  }
