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

  # gc stuff for home manager profiles
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };

  # https://nixos.wiki/wiki/Bluetooth [enabled mpris proxy for wireless buttons]
  # [enable this for each specific device that needs it than globally]
  # services.mpris-proxy.enable = true; 
}
