{
  pkgs,
  system,
  lib,
  inputs,
  sources,
  ...
}:
lib.fix (self: let
  inherit (lib) warn;
  inherit (pkgs) callPackage;
in {
  # kurukuru
  quickshell = import ./quickshell.nix {
    inherit (inputs.quickshell) rev;
    inherit
      (inputs.quickshell.packages.${system})
      quickshell
      ;
  };
  kurukurubar-unstable = callPackage ./kurukurubar.nix {
    inherit (self) quickshell;
    inherit (self) librebarcode scripts;
  };
  kurukurubar = (self.kurukurubar-unstable).override {
    inherit (pkgs) quickshell;
    # following zaphkiel master branch: quickshell v0.2.0
    # configPath = (sources.zaphkiel) + "/users/dots/quickshell/kurukurubar";
  };

  # trivial
  mpv-wrapped = callPackage ./mpv {};
  librebarcode = callPackage ./librebarcode.nix {};
  kokCursor = callPackage ./kokCursor.nix {};
  stash = inputs.stash.packages.${system}.default;
  irminsul = callPackage ./irminsul {inherit (self.scripts) qmlcheck;};
  winboat = callPackage ./winboat {inherit sources;};
  shpool = callPackage ./shpool.nix {inherit sources;};

  # overriding the derrivation
  # winslop = self.winboat.overrideAttrs (old: {
  #   guestDrv = old.guestDrv.overrideAttrs (new': old': {
  #     version = "0.8.6";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "TibixDev";
  #       repo = "winboat";
  #       tag = "v${new'.version}";
  #       hash = "sha256-Lvv+alPvQAcPFc8d+JC0hJX0sLjRL0/peJmMxiXNb0Q=";
  #     };
  #     vendorHash = "sha256-JglpTv1hkqxmcbD8xmG80Sukul5hzGyyANfe+GeKzQ4=";
  #   });
  # });

  # package sets
  scripts = callPackage ./scripts {};
  xvim = callPackage ./nvim {
    mnw = inputs.mnw.lib;
    inherit sources;
  };

  # JUST SO YOU KNOW `nivxvim` WAS JUST WHAT I USED TO CALL MY nvim alright
  # I had ditched the nixvim project long long long ago but the name just stuck
  nixvim-minimal = warn "Zahpkiel: `nixvim-minimal` depricated, please use `xvim.minimal` instead" self.xvim.minimal;
  nixvim = warn "Zahpkiel: `nixvim` depricated please use `xvim.default` instead" self.xvim.default;
})
