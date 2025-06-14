{
  lib,
  matugenColors,
  alpha ? 0.79,
  variant ? "dark",
}: let
  colors = matugenColors.${variant};
in
  lib.generators.toINI {} {
    colors = {
      inherit alpha;
      background = "${colors.background}";
      foreground = "${colors.on_background}";
      selection-foreground = "${colors.on_tertiary}";
      selection-background = "${colors.tertiary}";
      search-box-no-match = "${colors.secondary_container} ${colors.on_secondary_container}";
      search-box-match = "${colors.primary} ${colors.on_primary}";
      jump-labels = "${colors.primary} ${colors.on_primary}";
      urls = "${colors.tertiary}";
    };
    cursor = {
      color = "${colors.surface} ${colors.on_surface}";
    };
  }
