{
  pkgs,
  config,
  lib,
  ...
}: let
  username = "ancys";
  description = "Ancy Stanley";
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  # hjem
  hjem.users.${username} = {
    enable = true;
    user = username;
    directory = config.users.users.${username}.home;
    clobberFiles = lib.mkForce true;

    packages = [
      # nushell dependencies
      pkgs.starship
      pkgs.zoxide
      pkgs.carapace
    ];

    files = let
      matugen = config.programs.matugen;
      matugenTheme = matugen.theme.files;
      matugenColors = matugen.theme.colors;
      starship = let
        base = lib.importTOML ./Configs/starship/starship.toml;
        colors = lib.importTOML "${matugenTheme}/starship.toml";
      in
        pkgs.writers.writeTOML "starship.toml" (lib.recursiveUpdate base colors);
    in {
      # shell
      ".config/nushell/config.nu".source = ./Configs/nushell/config.nu;
      ".config/starship.toml".source = starship;

      # foot terminal
      ".config/foot/foot.ini".source = ./Configs/foot/foot.ini;
      ".config/foot/rose-pine.ini".source = ./Configs/foot/rose-pine.ini;
      ".config/foot/matugen-colors.ini".text = import ./Configs/foot/matugen.nix {
        inherit lib matugenColors;
      };
    };
  };
}
