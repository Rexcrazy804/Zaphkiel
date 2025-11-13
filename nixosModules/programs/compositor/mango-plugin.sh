#!/bin/false
# sourced by uwsm environment preloader

quirks_mango() {
  # append "wlroots" to XDG_CURRENT_DESKTOP if not already there
  if [ "${__WM_DESKTOP_NAMES_EXCLUSIVE__}" != "true" ]
  then
    case "A:${XDG_CURRENT_DESKTOP}:Z" in
      *:wlroots:*) true ;;
      *)
        export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}:wlroots"
        ;;
    esac
  fi

  # mark additional vars for export on finalize
  UWSM_FINALIZE_VARNAMES="${UWSM_FINALIZE_VARNAMES}${UWSM_FINALIZE_VARNAMES:+ }XCURSOR_SIZE"
  export UWSM_FINALIZE_VARNAMES
}

mango_environment2finalize() {
  # expects mango config.conf file content on stdin
  # adds varnames to UWSM_FINALIZE_VARNAMES
  while read -r line; do
    IFS='=' read -r key rest <<< "$line"
    if [ "$key" != "env" ]; then
      continue
    fi

    IFS=',' read -r var value <<< "$rest"
    case "$var" in
      *[!a-zA-Z0-9_]* | '') continue ;;
    esac

    UWSM_FINALIZE_VARNAMES="${UWSM_FINALIZE_VARNAMES}${UWSM_FINALIZE_VARNAMES:+ }$var"
  done
}

in_each_config_dir_reversed_mango() {
  # do normal stuff
  in_each_config_dir_reversed "$1"

  # fill UWSM_FINALIZE_VARNAMES with varnames from mango env files
  if [ -r "${1}/mango/config.conf" ]; then
    echo "Collecting varnames from \"${1}/mango/config.conf\""
    mango_environment2finalize < "${1}/mango/config.conf"
    export UWSM_FINALIZE_VARNAMES
  fi
}
