{self, ...}: {
  devShells = self.lib.eachSystem ({
    pkgs,
    system,
  }: let
    precommit = pkgs.writeShellScript "pre-commit" ''
      if irminsul chk FILES_STAGED=1; then
        exit 0
      else
        irminsul fmt FILES_STAGED=1
        exit 1
      fi
    '';
  in {
    default = pkgs.mkShellNoCC {
      shellHook = ''
        if ! [ -d .git ]; then
          echo "[SHELL] .git not found, skipping"
          exit 0
        fi
        HOOKS=$(pwd)/.git/hooks
        if ! [ -f "$HOOKS/pre-commit" ]; then
          install ${precommit} $HOOKS/pre-commit
          echo "[SHELL] created precommit hook :>"
        elif ! cmp --silent $HOOKS/pre-commit ${precommit}; then
          install ${precommit} $HOOKS/pre-commit
          echo "[SHELL] updated precommit hook ^OwO^"
        fi
      '';

      packages = [
        self.packages.${system}.irminsul
        pkgs.taplo
      ];
    };
  });
}
