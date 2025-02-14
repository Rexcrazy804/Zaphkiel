{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./steam.nix
    ./sddm.nix
    ./aagl.nix
    ./age.nix
  ];

  # global
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git p7zip unrar;
    nixvim = pkgs.wrappedPkgs.nvim-wrapped;
  };

  # wayland on electron and chromium based apps
  # disabled due to insanely slow startup time
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # direnv enabled by default force this of if required

  programs.direnv = {
    enable = true;
    silent = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
    # YOUVE GOT TO BE FUCKING KIDDING ME
    # ALL I HADDA DO WAS REBOOT AND I WASTED SO MANY HOURS?
    # AAAAAAAAAAAAAAAAA
    direnvrcExtra = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };
}
