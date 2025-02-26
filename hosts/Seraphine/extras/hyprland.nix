{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  environment.systemPackages = [
    pkgs.hyprpaper
    pkgs.wrappedPkgs.fuzzel
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.grim
    pkgs.slurp
  ];
}
