{lib, ...}: {
  packages = {
    alacritty.enable = lib.mkDefault true;
    discord.enable = lib.mkDefault true;
    obs.enable = lib.mkDefault true;
    mangohud.enable = lib.mkDefault true;
    mpv = {
      enable = lib.mkDefault true;
      anime4k.enable = lib.mkDefault true;
    };
  };

  packageGroup = {
    wine.enable = lib.mkDefault true;
    emulators.enable = lib.mkDefault false;
    multimedia.enable = lib.mkDefault true;
  };

  programs.git = {
    enable = true;
    userName = "Rexiel Scarlet";
    userEmail = "37258415+Rexcrazy804@users.noreply.github.com";
  };
}