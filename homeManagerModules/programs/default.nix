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
}
