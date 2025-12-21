{
  dandelion.modules.proton = {pkgs, ...}: {
    environment.sessionVariables = {
      "PROTON_ENABLE_WAYLAND" = 1;
      "PROTON_USE_WOW64" = 1;
      "PROTONPATH" = pkgs.proton-ge-bin.steamcompattool;
    };
    environment.etc."proton-ge".source = pkgs.proton-ge-bin.steamcompattool;
    environment.systemPackages = [pkgs.umu-launcher];
    programs.steam.extraCompatPackages = [pkgs.proton-ge-bin];
  };
}
