# lets me do
# nix-build ~/nixos/pkgs --argstr package nixvim
# to build the the exported packages
{
  sources ? import ../npins,
  pkgs ?
    import sources.nixpkgs {
      overlays = [(import ./overlays/internal.nix {inherit sources;})];
    },
  package,
}:
pkgs.${package}
