{self, ...}: {
  devShells = self.lib.eachSystem ({
    pkgs,
    pkgx,
    ...
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
        pkgx.irminsul
        pkgs.taplo
      ];
    };
  });
}
/*
   My hook doesn't work with jj so I am stashing my config here for reuse later
 * TODO look into jj fix
[aliases]
push = ["util", "exec", "--", "fish", "-c", """
if test "$(jj st | head -n 1)" != "The working copy has no changes."
  jj new
end
irminsul fmt FILES_ALL=1
if test "$(jj st | head -n 1)" = "The working copy has no changes."
  jj git push
end
""", ""]
*/

