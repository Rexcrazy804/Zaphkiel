{self, ...}: {
  dandelion.modules.environment = {pkgs, ...}: {
    environment.systemPackages = [
      (self.lib.mkPkgx' pkgs).xvim.default
      pkgs.git
      pkgs.npins
      pkgs.jujutsu
    ];

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
    # nano deez nutz
    programs.nano.enable = false;
  };
}
