#!/usr/bin/env bash

# append "wlroots" to XDG_CURRENT_DESKTOP if not already there
case "A:${XDG_CURRENT_DESKTOP}:Z" in
  *:wlroots:*) true ;;
  *) export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}:wlroots" ;;
esac

uwsm finalize XDG_CURRENT_DESKTOP XCURSOR_SIZE XCURSOR_THEME

# services
uwsm app -t service kurukurubar
uwsm app -t service foot -- --server
uwsm app -t service stash -- watch
uwsm app -t service wlsunset -- -s 17:30 -S 7:00
uwsm app nm-applet
