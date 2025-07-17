{
  pkgs,
  config,
  sources,
  lib,
  ...
}: let
  username = "rexies";
  description = "Rexiel Scarlet";
in {
  zaphkiel.data.users = [username];
  users.users.${username} = {
    inherit description;

    # its fish, but through bash
    # shell = pkgs.nushell;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "multimedia"];
    hashedPasswordFile = config.age.secrets.rexiesPass.path;

    # only declare common packages here
    # others: hosts/<hostname>/user-configuration.nix
    # if you declare something here that isn't common to literally every host I
    # will personally show up under your bed whoever and wherever you are
    packages = [
      pkgs.btop
      pkgs.git
      pkgs.bat
      pkgs.delta
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

    files = let
      matugen = config.programs.matugen;
      matugenTheme = matugen.theme.files;
      matugenColors = matugen.theme.colors;

      # replacing hardcoded paths
      qt6ct = let
        from = ["/home/rexies"];
        to = ["${config.users.users.${username}.home}"];
      in
        builtins.replaceStrings from to (builtins.readFile ./dots/qt6ct/qt6ct.conf);

      walkerCSSInjected = let
        from = [
          "%%error%%"
          "%%on_error%%"
          "%%on_surface%%"
          "%%surface%%"
          "%%surface_container%%"
          "%%surface_container_highest%%"
        ];

        to = [
          matugenColors.dark.error
          matugenColors.dark.on_error
          matugenColors.dark.on_surface
          matugenColors.dark.surface
          matugenColors.dark.surface_container
          matugenColors.dark.surface_container_highest
        ];
      in
        builtins.replaceStrings from to (builtins.readFile ./dots/walker/themes/custom.css);

      walkerTOMLInjected = let
        from = ["%%primary%%"];
        to = [matugenColors.dark.primary];
      in
        builtins.replaceStrings from to (builtins.readFile ./dots/walker/themes/custom.toml);

      faceIcon = let
        image = config.programs.booru-flake.images."8726475";
      in
        pkgs.runCommandWith {
          name = "croped-${image.name}";
          derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
        } ''
          magick ${image} -crop 500x500+398+100 - >  $out
        '';

      quickshellConfig = pkgs.runCommandLocal "quick" {} ''
        mkdir $out
        cd $out
        cp -rp ${./dots/quickshell/kurukurubar}/* .
        chmod u+rw ./Data/Colors.qml
        cp ${matugenTheme}/quickshell-colors.qml ./Data/Colors.qml
      '';
    in {
      # git
      ".config/git/config".source = ./dots/git/config;

      # face Icon
      ".face.icon".source = faceIcon;
      # shell
      # ".config/nushell/config.nu".source = ./dots/nushell/config.nu;
      # ".config/starship.toml".source = starship;
      ".config/fish/themes".source = sources.rosep-fish + "/themes";
      ".config/fish/config.fish".source = ./dots/fish/config.fish;
      # bat
      ".config/bat/config".source = ./dots/bat/config;
      # NOTE: required bat cache --build before theme can be used
      ".config/bat/themes".source = sources.catp-bat + "/themes";

      # foot terminal
      ".config/foot/foot.ini".source = ./dots/foot/foot.ini;
      ".config/foot/rose-pine.ini".source = sources.rosep-foot + "/rose-pine";

      # hyprland
      ".config/uwsm/env".source = ./dots/uwsm/env;
      ".config/hypr/hypridle.conf".source = ./dots/hyprland/hypridle.conf;
      ".config/hypr/hyprland.conf".source = ./dots/hyprland/hyprland.conf;
      ".config/hypr/hyprcolors.conf".source = "${matugenTheme}/hyprcolors.conf";
      ".config/yazi/yazi.toml".source = ./dots/yazi/yazi.toml;
      ".config/yazi/keymap.toml".source = ./dots/yazi/keymap.toml;
      ".config/yazi/theme.toml".source = "${matugenTheme}/yazi-theme.toml";
      ".config/background".source = matugen.wallpaper;

      # quickshell
      ".config/quickshell".source = quickshellConfig;

      # qt6ct
      ".config/qt6ct/qt6ct.conf".text = qt6ct;
      ".config/qt6ct/colors/matugen.conf".source = "${matugenTheme}/qtct-colors.conf";

      # walker
      ".config/walker/config.toml".source = ./dots/walker/config.toml;
      ".config/walker/themes/custom.css".text = walkerCSSInjected;
      ".config/walker/themes/custom.toml".text = walkerTOMLInjected;

      # discord
      ".config/vesktop/themes/midnight.css".source = "${matugenTheme}/discord-midnight.css";
    };
  };
}
