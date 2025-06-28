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
  qtDeps = [
    pkgs.quickshell
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
  ];
  qmlPath = pkgs.lib.pipe qtDeps [
    (builtins.map (lib: "${lib}/lib/qt-6/qml"))
    (builtins.concatStringsSep ":")
  ];
in
  pkgs.mkShell {
    shellHook = ''
      export QML2_IMPORT_PATH="$QML2_IMPORT_PATH:${qmlPath}"
    '';
    buildInputs = qtDeps;
    packages = [pkgs.material-symbols];
  }
