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

  # services.hypridle.package = pkgs.wrappedPkgs.hypridle;

  services.displayManager.defaultSession = "hyprland-uwsm";
  environment.systemPackages = pkgs.wrappedPkgs.hyprland.dependencies;
}
