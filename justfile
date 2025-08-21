#!/usr/bin/env nix-shell
#!nix-shell -i "just --justfile" --quiet
#!nix-shell -p just cached-nix-shell jq

REBUILD_CMD := require('nixos-rebuild')

alias rb := rebuild
alias sh := develop

_default:
    @just -l

# list available packages
[group("extra")]
list:
    @nix eval --file default.nix packages --json --read-only --apply \
    'x: builtins.mapAttrs (k: v: if v.meta ? description then v.meta.description else v.name) x' \
    | jq

# update npins sources
[group("extra")]
update +sources='':
    npins update {{ sources }}

# enter a nix repl with attrs from default.nix loaded
[group("extra")]
repl:
    nix repl --file .

# build a package
[group("nix")]
build package="default":
    nix-build -A packages.{{ package }}

# build and run a package
[group("nix")]
run package="default" +args="": (_run ("packages." + package) args)

# build and run the formatter
[group("nix")]
fmt +args=".": (_run "formatter" args)

_run attr args:
    @cached-nix-shell --expr "with import {{ `pwd` }} {}; {{ attr }}" --run \
      "$(nix eval --file default.nix {{ attr }}.meta.mainProgram --raw) {{ args }}"

# enter a devShell
[group("nix")]
develop shell="default":
    cached-nix-shell default.nix -A devShells.{{ shell }}

# rebuild nixos configuration
[group("nixos")]
rebuild cmd host=`hostname` +args='':
    {{ REBUILD_CMD }} --log-format bar --no-reexec --file . -A nixosConfigurations.{{ host }} {{ cmd }} {{ args }}
