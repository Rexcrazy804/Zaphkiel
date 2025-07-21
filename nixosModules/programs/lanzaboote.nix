{
  pkgs,
  lib,
  sources,
  config,
  ...
}: {
  imports = [(sources.lanzaboote + "/nix/modules/lanzaboote.nix")];
  options.zaphkiel.programs.lanzaboote.enable = lib.mkEnableOption "lanzaboote";
  config = lib.mkIf config.zaphkiel.programs.lanzaboote.enable {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # WARNING
      # this is from the internal overlay NOT THE SAME as pkgs.lanzaboote-tool
      # in nipxkgs which does NOT contain the required uefi stub
      package = pkgs.lanzaboote-tool;
      configurationLimit = 12;
    };
  };
}
