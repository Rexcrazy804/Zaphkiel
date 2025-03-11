{
  pkgs,
  mode ? "L+",
  source ? throw "source required",
  user ? throw "user required",
  destination ? throw "destination requried",
}: let
  home = "/home/${user}";
  target = home + "/" + destination;
in {
  # this is simply a function that creates symlinks to the home of the given user
  # for a usage example checkout nixosModules/programs/hyprland/default.nix
  # Heavily inspired by feel-co/hjem
  # Veedu is the term for "home" in malayalam (sounds a lot like a certain something ik)
  systemd.user.tmpfiles.users.${user}.rules = [
    "${mode} '${target}' - - - - ${source}"
  ];

  systemd.user.services.veedu-reload = {
    enable = true;
    description = "Force systemd tmpfiles to reload";
    wants = [ "systemd-tmpfiles-setup.service"];
    wantedBy = [ "graphical-session-pre.target" ];
    serviceConfig.Type = "oneshot";
    script = "echo 'veedu re-loaded'";
  };
}
