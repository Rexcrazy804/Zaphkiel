{pkgs, lib, config, ...}: {
  options = {
    packages = {
      discord.enable = lib.mkEnableOption "Enable Discord";
    };
  };

  config = lib.mkIf config.packages.discord.enable {
    home.packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
