{inputs, ...}: {
  imports =
    [
      ./groups
      ./sway

      ./alacritty.nix
      ./shell.nix
      ./mpv.nix
      ./mangohud.nix
      ./discord.nix
      ./obs.nix
      ./hyprland.nix
      ./firefox.nix
    ]
    ++ [
      inputs.agenix.homeManagerModules.default
    ];
}
