{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  environment.systemPackages = [
    pkgs.hyprpaper
  ];
}
