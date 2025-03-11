{
  mode ? "L+",
  source ? throw "source required",
  user ? throw "user required",
  destination ? throw "destination requried",
}: let
  home = "/home/${user}";
  target = home + "/" + destination;
in {
  # this is simply a function that creates symlinks to the home of the given user
  # for a usage example checkout nixosModules/hyprland/default.nix
  # Heavily inspired by feel-co/hjem
  systemd.user.tmpfiles.users.${user}.rules = [
    "${mode} '${target}' - - - - ${source}"
  ];
}
