{pkgs}: let
  catppucin-theme = [
    "bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8"
    "fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
    "marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    "selected-bg:#45475a"
    "border:#313244,label:#cdd6f4"
  ];
  fzf-options = builtins.concatStringsSep "\n" (builtins.map (option: "--color=" + option) catppucin-theme);
in
  pkgs.symlinkJoin {
    name = "fzf-wrapper";
    paths = [
      pkgs.fzf
    ];

    buildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      wrapProgram $out/bin/fzf \
        --set-default FZF_DEFAULT_OPTS "${fzf-options}"
    '';
  }
