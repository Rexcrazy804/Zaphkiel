#!/usr/bin/env bash
# borrowed from https://jade.fyi/blog/pinning-nixos-with-npins/

cd $(dirname $0)

# assume that if there are no args, you want to switch to the configuration
cmd=${1:-switch}
shift

nixpkgs_pin=$(nix eval --raw -f npins/default.nix nixpkgs)
nix_path="nixpkgs=${nixpkgs_pin}:nixos-config=$PWD/default.nix"
echo $nix_path

# without --fast, nixos-rebuild will compile nix and use the compiled nix to
# evaluate the config, wasting several seconds
sudo env HOSTNAME=${HOSTNAME} nixos-rebuild -I nixpkgs=${nixpkgs_pin} -I nixos-config=${PWD}/default.nix "$cmd" --no-reexec "$@"
