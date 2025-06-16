{
  sources ? (import ./npins),
  system ? builtins.currentSystem or "unknown-system",
  pkgs ? import sources.nixpkgs {inherit system;},
  buildPkg ? "default",
}: let
  compat = src: (import sources.flake-compat {inherit src;}).outputs;
  packages = rec {
    hello = pkgs.hello;
    default = hello;
  };
in
  packages.${buildPkg}
