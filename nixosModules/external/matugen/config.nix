{...}: {
  programs.matugen.templates = {
    hyprland = {
      input_path = "${./templates/hyprland-colors.conf}";
      output_path = "~/hyprcolors.conf";
    };

    starship = {
      input_path = "${./templates/starship-colors.toml}";
      output_path = "~/starship.toml";
    };

    midnight-discord = {
      input_path = "${./templates/midnight-discord.css}";
      output_path = "~/discord-midnight.css";
    };

    gtk3 = {
      input_path = "${./templates/gtk-colors.css}";
      output_path = "~/gtk3-colors.css";
    };

    gtk4 = {
      input_path = "${./templates/gtk-colors.css}";
      output_path = "~/gtk4-colors.css";
    };

    yazi = {
      input_path = "${./templates/yazi-theme.toml}";
      output_path = "~/yazi-theme.toml";
    };

    fuzzel = {
      input_path = "${./templates/fuzzel.ini}";
      output_path = "~/fuzzel.ini";
    };
  };
}
