#!/usr/bin/env bash
uwsm finalize
# see if this is really needed
# dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
uwsm app -t service kurukurubar
uwsm app -t service foot -- --server
uwsm app -t service stash -- watch
uwsm app -t service wlsunset -- -s 17:30 -S 7:00
uwsm app nm-applet
