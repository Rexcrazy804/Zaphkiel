# primary reference https://gitlab.com/fazzi/nixohess/-/blob/main/modules/gaming/default.nix
{
  dandelion.modules.wine = {
    pkgs,
    lib,
    config,
    ...
  }: {
    users.users = lib.genAttrs config.zaphkiel.data.users (_user: {
      extraGroups = ["video" "input"];
    });

    boot.kernelModules = ["ntsync"];
    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0644"
    '';

    environment.systemPackages = [
      pkgs.wineWowPackages.waylandFull
      pkgs.winetricks
      pkgs.mono
    ];
  };
}
