#!/usr/bin/env bash

uwsm finalize

# services
systemd-run --user --slice=background-graphical.slice -u shell kurukurubar
systemd-run --user --slice=background-graphical.slice -u nightlight wlsunset -s 17:30 -S 7:00
systemd-run --user --slice=background.slice -u terminal-server foot --server
systemd-run --user --slice=background.slice -u clipboard-manager stash watch
systemd-run --user --slice=background.slice -u nm-applet nm-applet
