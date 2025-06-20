#!/usr/bin/env bash
nixpkgs=$(nix eval --raw -f npins/default.nix nixpkgs)
nix-build --log-format bar-with-logs $nixpkgs/nixos -A config.system.build.vm -I nixos-config=$(pwd)
