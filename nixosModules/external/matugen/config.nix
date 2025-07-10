{...}: {
  programs.matugen.templates = {
    hyprland = {
      input_path = "${./templates/hyprland-colors.conf}";
      output_path = "~/hyprcolors.conf";
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
      input_path = "${./templates/fuzzel-colors.ini}";
      output_path = "~/fuzzel-colors.ini";
    };

    qtct = {
      input_path = "${./templates/qtct-colors.conf}";
      output_path = "~/qtct-colors.conf";
    };

    quickshell = {
      input_path = "${./templates/quickshell-colors.qml}";
      output_path = "~/quickshell-colors.qml";
    };
  };
}
