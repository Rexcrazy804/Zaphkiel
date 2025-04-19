{
  pkgs,
  config,
  lib,
  ...
}: let
  username = "rexies";
  description = "Rexiel Scarlet";
in {
  users.users.${username} = {
    inherit description;

    shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "multimedia"];
    hashedPasswordFile = config.age.secrets.rexiesPass.path;

    # only declare common packages here
    # others: hosts/<hostname>/user-configuration.nix
    packages = [
      pkgs.btop
      (pkgs.wrappedPkgs.git.override {
        username = description;
        email = "37258415+Rexcrazy804@users.noreply.github.com";
      })
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICELSL45m4ptWDZwQDi2AUmCgt4n93KsmZtt69fyb0vy rexies@Zaphkiel"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZTLQQzgCvdaAPdxUkpytDHgwd8K1N1IWtriY4tWSvn rexies@Raphael"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICZvsZTvR5wQedjnuSoz9p7vK7vLxCdfOdRFmbfQ7GUd rexies@Seraphine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH8XCGfozlovdRKSzI8mRL7Bkexk+GoK+WCTWxVmBmDA rexies@Persephone"
    ];
  };

  # define secrets
  age.secrets.rexiesPass = {
    file = ../secrets/secret1.age;
    owner = username;
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

      # replacing hardcoded paths
      hyprpanel = let
        from = ["/home/rexies/Pictures/kokomi_116824847_p0_cropped.jpg"];
        to = ["${matugen.wallpaper}"];
      in
        builtins.replaceStrings from to (builtins.readFile ./Configs/hyprpanel/config.json);
      qt6ct = let
        from = ["/home/rexies"];
        to = ["${config.users.users.${username}.home}"];
      in
        builtins.replaceStrings from to (builtins.readFile ./Configs/qt6ct/qt6ct.conf);

      # injecting colors
      fuzzel = let
        base = builtins.readFile ./Configs/fuzzel/fuzzel.ini;
        colors = builtins.readFile "${matugenTheme}/fuzzel-colors.ini";
      in
        base + colors;
      starship = let
        base = lib.importTOML ./Configs/starship/starship.toml;
        colors = lib.importTOML "${matugenTheme}/starship.toml";
      in
        pkgs.writers.writeTOML "starship.toml" (lib.recursiveUpdate base colors);

      hyprlockInjected = let 
        from = ["%%WALLPAPER%%"];
        to = ["${matugen.wallpaper}"];
      in builtins.replaceStrings from to (builtins.readFile ./Configs/hyprland/hyprlock.conf);
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

      # qt6ct
      ".config/qt6ct/qt6ct.conf".text = qt6ct;
      ".config/qt6ct/colors/matugen.conf".source = "${matugenTheme}/qtct-colors.conf";

      # hyprland
      ".config/hypr/hypridle.conf".source = ./Configs/hyprland/hypridle.conf;
      ".config/hypr/hyprland.conf".source = ./Configs/hyprland/hyprland.conf;
      ".config/hypr/hyprlock.conf".text = hyprlockInjected;
      ".config/hypr/hyprcolors.conf".source = "${matugenTheme}/hyprcolors.conf";
      ".config/yazi/yazi.toml".source = ./Configs/yazi/yazi.toml;
      ".config/yazi/keymap.toml".source = ./Configs/yazi/keymap.toml;
      ".config/yazi/theme.toml".source = "${matugenTheme}/yazi-theme.toml";
      ".config/hyprpanel/config.json".text = hyprpanel;
      ".config/fuzzel/fuzzel.ini".text = fuzzel;
      ".config/background".source = matugen.wallpaper;

      # discord
      ".config/Vencord/themes/midnight.css".source = "${matugenTheme}/discord-midnight.css";
    };
  };
}
