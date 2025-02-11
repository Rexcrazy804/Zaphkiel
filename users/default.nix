{
  users,
  ...
}: {
  # refer ExtraSpecialArgs.users in flake.nix
  imports =
    [./Wrappers]
    ++ builtins.map (username: ./${username}.nix) users;
}
