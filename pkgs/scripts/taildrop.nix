{
  writeShellScriptBin,
  fzf,
}:
writeShellScriptBin "taildrop" ''
  # tailscale needs to be on the system to do this anyways
  # so I am not using it's store path
  tailscale status | awk '!/.*tagged-devices.*|offline/ { print $2 }' | ${fzf}/bin/fzf | xargs -I % tailscale file cp $@ %:
''
# NOTE
# you need set yourself as the operator for this to suceed
# see --operator flag in tailscale cli's set subcommand

