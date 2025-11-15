{nixpkgs, ...}: {
  dandelion.modules.nix = {pkgs, ...}: let
    script = pkgs.writers.writeNuBin "activate" ''
      def main [systemConfig: string] {
        let diff_closure = ${pkgs.nix}/bin/nix store diff-closures /run/current-system $systemConfig;
        if $diff_closure != "" {
          let table = $diff_closure
          | lines
          | where $it =~ KiB
          | where $it =~ →
          | parse -r '^(?<Package>\S+): (?<Old_Version>[^,]+)(?:.*) → (?<New_Version>[^,]+)(?:.*, )(?<DiffBin>.*)$'
          | insert Diff {
            get DiffBin
            | ansi strip
            | str trim -l -c '+'
            | into filesize
          }
          | reject DiffBin
          | sort-by -r Diff;

          print $table;
          $table | math sum
        }
      }
    '';
  in {
    nixpkgs.config.allowUnfree = true;
    nix = {
      package = pkgs.nixVersions.nix_2_30;
      registry.nixpkgs.flake = nixpkgs;
      channel.enable = false;
      settings = {
        allow-import-from-derivation = false;
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;
        trusted-users = ["root" "@wheel"];

        extra-substituters = ["https://rexielscarlet.cachix.org"];
        extra-trusted-public-keys = ["rexielscarlet.cachix.org-1:wGoHtlmAIuGW/LgcqtFLb1RhgGZaUYGys8Okpopt3A0="];
      };
      gc = {
        persistent = true;
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };
    system.activationScripts.diff = ''
      if [[ -e /run/current-system ]]; then
        ${script}/bin/activate "$systemConfig"
      fi
    '';
  };
}
