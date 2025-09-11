{
  pkgs,
  mkShellNoCC,
}: let
  precommit = pkgs.writeShellScript "pre-commit" ''
    if nix fmt chk FILES_STAGED=1; then
      exit 0
    else
      nix fmt fmt FILES_STAGED=1
      exit 1
    fi
  '';
in
  mkShellNoCC {
    shellHook = ''
      HOOKS=$(pwd)/.git/hooks
      if ! [ -f "$HOOKS/pre-commit" ]; then
        install ${precommit} $HOOKS/pre-commit
        echo "[SHELL] created precommit hook :>"
      elif ! cmp --silent $HOOKS/pre-commit ${precommit}; then
        install ${precommit} $HOOKS/pre-commit
        echo "[SHELL] updated precommit hook ^OwO^"
      fi
    '';
  }
