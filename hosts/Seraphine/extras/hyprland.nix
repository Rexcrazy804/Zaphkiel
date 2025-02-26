{pkgs, ...}: {
  programs.hyprland = {
    package = pkgs.wrappedPkgs.hyprland;
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock = {
    enable = true;
    package = pkgs.wrappedPkgs.hyprlock;
  };

  services.displayManager.defaultSession = "hyprland-uwsm";
}
