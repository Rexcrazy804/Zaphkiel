#!/usr/bin/env bash
uwsm finalize
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
uwsm app -t service kurukurubar
uwsm app -t service foot -- --server
uwsm app -t service stash -- watch
uwsm app nm-applet
