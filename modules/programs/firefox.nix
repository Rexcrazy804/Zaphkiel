{
  dandelion.modules.firefox = {pkgs, ...}: {
    programs.firefox = {
      package = pkgs.librewolf;
      enable = true;
    };
  };
}
