{
  inputs,
  config,
  users,
  ...
}: let
  hostname = config.networking.hostName;
in {
  # refer ExtraSpecialArgs.users in flake.nix
  imports =
    [./Wrappers]
    ++ builtins.map (username: ./${username}.nix) users;
}
