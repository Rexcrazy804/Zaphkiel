{
  pkgs,
  lib,
  ...
}: let
  kde-send =
    pkgs.writers.writeNuBin "kde-send"
    {
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [pkgs.fzf]}"
      ];
    }
    /*
    nu
    */
    ''
      def main [...files] {
        let device = kdeconnect-cli -a --name-only | fzf

        for $file in $files {
          kdeconnect-cli -n $"($device)" --share $"($file)"
        }
      }
    '';
in
  pkgs.symlinkJoin {
    name = "yazi-wrapper";
    paths = [
      kde-send
      pkgs.yazi
      pkgs.ripdrag
    ];
    buildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/yazi \
        --set-default YAZI_CONFIG_HOME ${./config} \
    '';
  }
