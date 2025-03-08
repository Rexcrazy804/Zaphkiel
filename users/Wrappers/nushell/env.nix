{
  pkgs,
  lib,
  poshconfig,
}:
/*
nu
*/
''
  let zoxide_cache = $"($env.HOME)/.cache/zoxide"
  let carapace_cache = $"($env.HOME)/.cache/carapace"
  let oh_my_posh_cache = $"($env.HOME)/.cache/oh-my-posh"

  if not ($zoxide_cache | path exists) { mkdir $zoxide_cache }
  if not ($oh_my_posh_cache | path exists) { mkdir $oh_my_posh_cache }
  if not ($carapace_cache | path exists) { mkdir $carapace_cache }

  ${lib.getExe pkgs.zoxide} init nushell --cmd cd
  | sed 's/($env | default false __zoxide_hooked | get __zoxide_hooked/\0 | into bool/'
  | save --force $"($zoxide_cache)/init.nu"

  ${lib.getExe pkgs.oh-my-posh} init nu ${lib.optionalString (poshconfig != null) "--config ${poshconfig}"} --print
  | save --force $"($oh_my_posh_cache)/init.nu"

  ${lib.getExe pkgs.carapace} _carapace nushell
  | save -f $"($carapace_cache)/init.nu"
''
