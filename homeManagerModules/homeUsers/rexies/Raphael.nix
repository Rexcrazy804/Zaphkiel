{lib, ...}: {
  imports = [
    ./common.nix
  ];

  packages = {
    discord.enable = lib.mkForce false;
    obs.enable = lib.mkForce false;
    mangohud.enable = lib.mkForce false;
    mpv = {
      anime4k.enable = lib.mkForce false;
    };
  };

  programs.mpv.config.gpu-context = lib.mkForce "x11egl";
}
