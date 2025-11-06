{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption map catAttrs;
  inherit (lib) listToAttrs nameValuePair;
  inherit (lib.types) submodule singleLineStr path listOf;

  cfg = config.games;

  entryType = submodule (self: {
    options = {
      name = mkOption {
        type = singleLineStr;
        description = "Name of the Game";
        example = "Reverse 1999";
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
in {
  options.games = {
    enable = mkEnableOption "umu game configs and desktop entries";
    entries = mkOption {
      type = listOf entryType;
      default = [];
      apply = map (entry: let
        inherit (entry.umu) game_id;
        tomlFile = pkgs.writers.writeTOML "${game_id}.toml" {inherit (entry) umu;};
      in {
        desktopFile = pkgs.makeDesktopItem {
          name = game_id;
          desktopName = entry.name;
          exec = "umu-run --config ${config.xdg.config.directory}/games/${game_id}.toml";
          categories = ["Game"];
        };
        umuConfig = nameValuePair "games/${game_id}.toml" {source = tomlFile;};
      });
    };
    desktopFiles = mkOption {
      readOnly = true;
      default = catAttrs "desktopFile" cfg.entries;
    };
    umuConfigs = mkOption {
      readOnly = true;
      default = catAttrs "umuConfig" cfg.entries;
      apply = listToAttrs;
    };
    # DEBUGGING only
    # first = mkOption {
    #   readOnly = true;
    #   default = builtins.elemAt cfg.desktopFiles 0;
    # };
  };

  config = mkIf cfg.enable {
    packages = cfg.desktopFiles;
    xdg.config.files = cfg.umuConfigs;
  };
}
