{
  nixpkgs,
  self,
  ...
}: let
  inherit (nixpkgs.lib) genAttrs nixosSystem attrNames;

  mkHost = hostName: nixosSystem {modules = [self.dandelion.hosts.${hostName}];};
  hosts = attrNames self.dandelion.hosts;
in {
  nixosConfigurations = genAttrs hosts mkHost;
}
