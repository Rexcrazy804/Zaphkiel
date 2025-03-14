{
  pkgs,
  lib,
  matyouconf ? {
    contrast = 0;
    mode = "dark";
  },
  extra-config ? {},
}:
pkgs.symlinkJoin {
  name = "matugen-wrapper";
  paths = [pkgs.matugen];
  buildInputs = [pkgs.makeWrapper];

  postBuild = let
    config = lib.recursiveUpdate (import ./config.nix) extra-config;
    configfile = pkgs.writers.writeTOML "matugen.toml" config;
  in ''
    wrapProgram $out/bin/matugen \
      --add-flags "--contrast ${toString matyouconf.contrast}" \
      --add-flags "--mode ${matyouconf.mode}" \
      --add-flags "--config ${configfile}"
  '';

  meta.mainProgram = "matugen";
}
