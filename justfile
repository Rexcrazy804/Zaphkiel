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

# symlink dots to .config for rapid iteration
[group("extra")]
link target:
    #!/usr/bin/env bash
    set -euo pipefail
    ROOT_DIR={{ justfile_directory() }}
    DOTS_DIR=$ROOT_DIR/users/dots
    NIX_FILE=$ROOT_DIR/users/rexies.nix
    function symlink() {
        if [[ -e "$2" && ! -L "$2" ]] ; then 
            echo "$2 exists and is not a symlink. Ignoring it." >&2
            return 1
        fi
        mkdir -p $(dirname $2)
        ln -sfv "${DOTS_DIR}/$1" "$2"
    }
    TO_LINK=$(cat $NIX_FILE | 
      awk '/\.\/dots\/{{ replace(target, '/', '\/') }}/ { 
        gsub(/\.source|"/, "", $1); 
        gsub(/\.\/dots\/|;/, "", $3); 
        print $3","$1
      }')

    for LINK in $TO_LINK; do
      CONFIG_FILE=${LINK##*,}
      DOTS_FILE=${LINK%%,*}
      symlink $DOTS_FILE ~/.config/$CONFIG_FILE
    done;

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
