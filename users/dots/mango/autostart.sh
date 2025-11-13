#!/usr/bin/env bash

# append "wlroots" to XDG_CURRENT_DESKTOP if not already there
case "A:${XDG_CURRENT_DESKTOP}:Z" in
  *:wlroots:*) true ;;
  *) export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP}:wlroots" ;;
esac

uwsm finalize XDG_CURRENT_DESKTOP XCURSOR_SIZE XCURSOR_THEME

# services
app2unit -t service -s s kurukurubar
app2unit -t service -s b foot --server
app2unit -t service -s b stash watch
app2unit -t service -s b wlsunset -s 17:30 -S 7:00
app2unit -t service -s a nm-applet
