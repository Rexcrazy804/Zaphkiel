{pkgs, ...}:
pkgs.symlinkJoin {
  name = "wezterm-wrapper";
  paths = [
    pkgs.wezterm
  ];

  buildInputs = [
    pkgs.makeWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/wezterm \
      --set-default WEZTERM_CONFIG_FILE ${./wezterm.lua}
    wrapProgram $out/bin/wezterm-gui \
      --set-default WEZTERM_CONFIG_FILE ${./wezterm.lua}
  '';
}
