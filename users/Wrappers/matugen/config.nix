{
  colorspath ? "~/nixos/users/Wrappers/matugen/colors"
}: {
  config = {
  };

  templates.hyprland = {
    input_path = "${./templates/hyprland-colors.conf}";
    output_path = "${colorspath}/hyprcolors.conf";
    post_hook = "hyprctl reload";
  };

  templates.discord = {
    input_path = "${./templates/midnight-discord.css}";
    output_path = "${colorspath}/discord.css";
  };
}
