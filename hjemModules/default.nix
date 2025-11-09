{
  pkgs,
  inputs,
  ...
}: {
  hjem = {
    extraModules = [
      inputs.hjem-impure.hjemModules.default
      ./games.nix
    ];
    linker = pkgs.smfh;
  };
}
