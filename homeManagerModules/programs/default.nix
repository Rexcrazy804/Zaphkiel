{inputs, ...}: {
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
  ] ++ [
    inputs.agenix.homeManagerModules.default
  ];
}
