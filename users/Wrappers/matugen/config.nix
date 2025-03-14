{
  colorspath ? "~/nixos/users/Wrappers/matyou/colors"
}: {
  config = {
  };

  templates.hyprland = {
    input_path = "${./templates/hyprland-colors.conf}";
    output_path = "${colorspath}/hyprcolors.conf";
    post_hook = "hyprctl reload";
  };
}
