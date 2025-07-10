{
  sources,
  users,
  ...
}: {
  # refer ExtraSpecialArgs.users in flake.nix
  imports = [(sources.hjem + "/modules/nixos")] ++ builtins.map (username: ./${username}.nix) users;
}
