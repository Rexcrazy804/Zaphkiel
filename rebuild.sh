#!/usr/bin/env bash
# borrowed from https://jade.fyi/blog/pinning-nixos-with-npins/

cd $(dirname $0)

# assume that if there are no args, you want to switch to the configuration
cmd=${1:-switch}
shift

nixpkgs_pin=$(nix eval --raw -f npins/default.nix nixpkgs)
# without --fast, nixos-rebuild will compile nix and use the compiled nix to
# evaluate the config, wasting several seconds
sudo HOSTNAME=${HOSTNAME} nixos-rebuild --log-format bar-with-logs -I nixpkgs=${nixpkgs_pin} -I nixos-config=${PWD}/default.nix "$cmd" --no-reexec "$@"
