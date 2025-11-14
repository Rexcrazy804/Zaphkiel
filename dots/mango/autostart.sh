#!/usr/bin/env bash

uwsm finalize

# services
app2unit -t service -s s kurukurubar
app2unit -t service -s b foot --server
app2unit -t service -s b stash watch
app2unit -t service -s b wlsunset -s 17:30 -S 7:00
app2unit -t service -s a nm-applet
