{
  inputs,
  mein,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) system;
  packages = lib.attrValues {
    # wine
    inherit (pkgs.wineWowPackages) waylandFull;
    inherit (pkgs.heroic-unwrapped) legendary;
    inherit (pkgs) bottles winetricks mono umu-launcher;
    # terminal
    inherit (pkgs) foot remmina libsixel;

    # from exported packages
    inherit (mein.${system}) mpv-wrapped equibop;
    inherit (mein.${system}.scripts) wallcrop legumulaunch;

    booru-hs = inputs.booru-hs.packages.${pkgs.system}.default;

    # discord = pkgs.discord.override {withMoonlight = true;};
  };
in {
  users.users."rexies" = {
    inherit packages;
    extraGroups = ["video" "input"];
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  zaphkiel = {
    data.wallpaper = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/8c/5d/__rubuska_and_corvus_reverse_1999__8c5da40a6b3a247b20327f0c0d71d2b9.jpg";
      hash = "sha256-Gzk5CRaMnu5WJUvg3SUpnS15FdrPvONcN5bBRdxIFtY=";
    };
    programs.matugen.scheme = "scheme-fidelity";
  };

  hjem.users.rexies.files.".face.icon".source = pkgs.stdenvNoCC.mkDerivation {
    name = "face.jpg";
    nativeBuildInputs = [pkgs.imagemagick];
    src = pkgs.fetchurl {
      url = "https://cdn.donmai.us/original/e9/c3/e9c3dbb346bb4ea181c2ae8680551585.jpg";
      hash = "sha256-0RKzzRxW1mtqHutt+9aKzkC5KijIiVLQqW5IRFI/IWY=";
    };
    dontUnpack = true;
    installPhase = "
        magick $src -crop 640x640+2300+1580 $out
      ";
  };

  hjem.users.rexies.games = {
    enable = true;
    entries = [
      {
        name = "Reverse 1999";
        umu.game_id = "rev199";
        umu.exe = "/home/rexies/Games/Reverse1999en/reverse1999.exe";
      }
    ];
  };
}
