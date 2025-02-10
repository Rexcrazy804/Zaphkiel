{
  pkgs,
  lib,
  poshconfig ? null,
}:
/*
nu
*/
''
  let zoxide_cache = $"($env.HOME)/.cache/zoxide"
  if not ($zoxide_cache | path exists) {
    mkdir $zoxide_cache
  }
  ${lib.getExe pkgs.zoxide} init nushell --cmd cd
  | sed 's/($env | default false __zoxide_hooked | get __zoxide_hooked/\0 | into bool/'
  | save --force $"($zoxide_cache)/init.nu"

  let oh_my_posh_cache = $"($env.HOME)/.cache/oh-my-posh"
  if not ($oh_my_posh_cache | path exists) {
    mkdir $oh_my_posh_cache
  }
  ${lib.getExe pkgs.oh-my-posh} init nu ${lib.optionalString (poshconfig != null) "--config ${poshconfig}"} --print
  | save --force $"($oh_my_posh_cache)/init.nu"

  let carapace_cache = $"($env.HOME)/.cache/carapace"
  if not ($carapace_cache | path exists) {
    mkdir $carapace_cache
  }
  ${lib.getExe pkgs.carapace} _carapace nushell
  | save -f $"($carapace_cache)/init.nu"
''
