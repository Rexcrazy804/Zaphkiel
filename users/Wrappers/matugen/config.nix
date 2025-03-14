{
  config = {};

  templates.hyprland = {
    input_path = "${./templates/hyprland-colors.conf}";
    output_path = "~/nixos/users/Wrappers/hyprland/conf/hyprcolors.conf";
    post_hook = "hyprctl reload";
  };

  templates.midnight-discord = {
    input_path = "${./templates/midnight-discord.css}";
    output_path = "~/.config/Vencord/themes/midnight.css";
  };

  templates.gtk3 = {
    input_path = "${./templates/gtk-colors.css}";
    output_path = "~/.config/gtk-3.0/colors.css";
  };

  templates.gtk4 = {
    input_path = "${./templates/gtk-colors.css}";
    output_path = "~/.config/gtk-4.0/colors.css";
  };

  templates.yazi = {
    input_path = "${./templates/yazi-theme.toml}";
    output_path = "~/nixos/users/Wrappers/yazi/config/theme.toml";
  };

  templates.fuzzel = {
    input_path = "${./templates/fuzzel.ini}";
    output_path = "~/nixos/users/Wrappers/fuzzel/colors.ini";
  };
}
