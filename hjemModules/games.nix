# A module for creating umu configs and desktop file for launching games
# via umu-launcher and proton-ge-bin provided by nixpkgs
# nixosModules/programs/wine.nix contains code for NTSYNC + wayland setup
# Usage: see hosts/Persephone/user-configuration.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption map toList;
  inherit (lib) listToAttrs nameValuePair catAttrs;
  inherit (lib.types) submodule singleLineStr path listOf attrs;
  inherit (lib.lists) allUnique;

  cfg = config.games;

  entryType = submodule (self: {
    options = {
      name = mkOption {
        type = singleLineStr;
        description = "Name of the Game";
        example = "Reverse 1999";
      };
      overrides = mkOption {
        type = attrs;
        default = {};
        description = "attrs merged with attrset passed to makeDesktopItem";
        apply = x: y: y // x;
      };
      # see https://github.com/Open-Wine-Components/umu-launcher/blob/main/docs/umu.5.scd
      umu = {
        prefix = mkOption {
          type = path;
          default = "${config.directory}/Games/umu/${self.config.umu.game_id}";
        };
        proton = mkOption {
          type = path;
          default = pkgs.proton-ge-bin.steamcompattool;
        };
        exe = mkOption {
          type = path;
          description = "Absolute path to game executable";
          example = "/home/rexies/Games/Reverse1999en/reverse1999.exe";
        };
        game_id = mkOption {
          type = singleLineStr;
          description = "Game id as in umu spec, or any random name for the prefix really";
          example = "corvus";
        };
      };
    };
  });

  processEntries = map (entry: let
    inherit (entry.umu) game_id;
  in {
    desktopFile = pkgs.makeDesktopItem (entry.overrides {
      name = game_id;
      desktopName = entry.name;
      exec = "umu-run --config ${config.xdg.config.directory}/games/${game_id}.toml";
      categories = ["Game"];
    });
    umuConfig = nameValuePair "games/${game_id}.toml" {
      generator = pkgs.writers.writeTOML "${game_id}.toml";
      value = {inherit (entry) umu;};
    };
  });
in {
  options.games = {
    enable = mkEnableOption "umu game configs and desktop entries";
    entries = mkOption {
      type = listOf entryType;
      default = [];
    };
    _entries = mkOption {
      readOnly = true;
      default = cfg.entries;
      apply = processEntries;
      description = "internal representation of entries";
    };
    desktopFiles = mkOption {
      readOnly = true;
      default = catAttrs "desktopFile" cfg._entries;
      description = "Desktop files for each entry";
    };
    umuConfigs = mkOption {
      readOnly = true;
      default = catAttrs "umuConfig" cfg._entries;
      apply = listToAttrs;
      description = "hjem compatible representation of each umu configuration";
    };
    # first = mkOption {
    #   readOnly = true;
    #   default = builtins.elemAt cfg.desktopFiles 0;
    # };
  };

  config = mkIf cfg.enable {
    assertions = toList {
      assertion = allUnique (map (e: e.umu.game_id) cfg.entries);
      message = "hjem.games.entries: game id's must be unique!";
    };
    packages = cfg.desktopFiles;
    xdg.config.files = cfg.umuConfigs;
  };
}
