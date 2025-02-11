{
  pkgs,
  lib,
  poshconfig ? null,
}: let
  config = pkgs.writers.writeNu "config.nu" (import ./config.nix {inherit pkgs lib;});
  env-config = pkgs.writers.writeNu "env.nu" (import ./env.nix {
    inherit pkgs;
    inherit (pkgs) lib;
    poshconfig =
      if (poshconfig != null)
      then poshconfig
      else ./poshconfig.json;
  });
in
  (pkgs.symlinkJoin {
    name = "nushell";
    paths = [
      pkgs.nushell
      pkgs.direnv
      pkgs.zoxide
      pkgs.carapace
      pkgs.oh-my-posh
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/nu \
      --append-flags '--config ${config} --env-config ${env-config}'
    '';
  })
  .overrideAttrs (_: {
    passthru = {
      shellPath = "/bin/nu";
    };
  })
