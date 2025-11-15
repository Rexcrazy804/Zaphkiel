{
  nixpkgs,
  self,
  ...
}: let
  inherit (nixpkgs.lib) genAttrs nixosSystem attrNames;
  mkHost = hostName:
    nixosSystem {
      modules = [
        self.dandelion.hosts.${hostName}
        self.dandelion.profiles.default
      ];
    };
  hosts = attrNames self.dandelion.hosts;
in {
  nixosConfigurations = genAttrs hosts mkHost;
}
