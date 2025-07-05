# lets me do the following to build the the exported packages
# nix-build ~/nixos/pkgs -A <package name>
{sources ? import ../npins}:
import sources.nixpkgs {
  overlays = [(import ./overlays/internal.nix {inherit sources;})];
}
