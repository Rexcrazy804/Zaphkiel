{
  pkgs,
  lib,
  scripts,
  mbake,
  mkShellNoCC,
}: let
  precommit = pkgs.writeShellScript "pre-commit" ''
    if make chk FILES_STAGED=1; then
      exit 0
    else
      make fmt FILES_STAGED=1
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
    packages = lib.attrValues {
      # formatters
      inherit (pkgs) alejandra luaformatter mdformat;
      inherit (pkgs.qt6) qtdeclarative;
      inherit (scripts) qmlcheck;
      # had to fix checking upstream (temp)
      # TODO use pkgs.mbake once changes are upstreamed (3 years?)
      inherit mbake;
      # TODO remove gnumake once migration is complete
      inherit (pkgs) gnumake just jq;
    };
  }
