{lib, ...}: {
  imports = [
    ./groups
    ./sway

    ./alacritty.nix
    ./shell.nix
    ./mpv.nix
    ./mangohud.nix
    ./discord.nix
    ./obs.nix
    ./hyprland.nix
    ./stylix.nix
  ];

  # special case
  stylix.enable = lib.mkOverride 60 false;
}
