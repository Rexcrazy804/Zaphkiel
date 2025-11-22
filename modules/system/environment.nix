{self, ...}: {
  dandelion.modules.environment = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.system}.xvim.default
      pkgs.git
      pkgs.npins
    ];

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    # nano deez nutz
    programs.nano.enable = false;
  };
}
