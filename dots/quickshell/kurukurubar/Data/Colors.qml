pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import qs.Data as Dat

Singleton {
  property var current: (true) ? dark : light
  property alias dark: dark
  property alias light: light

  function withAlpha(color: color, alpha: real): color {
    return Qt.rgba(color.r, color.g, color.b, alpha);
  }

  FileView {
    path: {
      const colors_location = (Quickshell.env("KURU_COLORS"));
      if (colors_location) {
        colors_location;
      } else {
        Dat.Paths.config + "/colors.json";
      }
    }
    watchChanges: true

    onAdapterUpdated: writeAdapter()
    onFileChanged: reload()

    // writes the defualt values if file not found
    onLoadFailed: err => {
      if (err == FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: adapter

      property JsonObject colors: JsonObject {
        property JsonObject dark: JsonObject {
          id: dark

          property string background: "#121318"
          property string error: "#ffb4ab"
          property string error_container: "#93000a"
          property string inverse_on_surface: "#2f3036"
          property string inverse_primary: "#4d5c92"
          property string inverse_surface: "#e3e1e9"
          property string on_background: "#e3e1e9"
          property string on_error: "#690005"
          property string on_error_container: "#ffdad6"
          property string on_primary: "#1d2d61"
          property string on_primary_container: "#dce1ff"
          property string on_primary_fixed: "#04174b"
          property string on_primary_fixed_variant: "#354479"
          property string on_secondary: "#2b3042"
          property string on_secondary_container: "#dee1f9"
          property string on_secondary_fixed: "#161b2c"
          property string on_secondary_fixed_variant: "#424659"
          property string on_surface: "#e3e1e9"
          property string on_surface_variant: "#c6c5d0"
          property string on_tertiary: "#432740"
          property string on_tertiary_container: "#ffd7f5"
          property string on_tertiary_fixed: "#2c122a"
          property string on_tertiary_fixed_variant: "#5b3d57"
          property string outline: "#90909a"
          property string outline_variant: "#45464f"
          property string primary: "#b6c4ff"
          property string primary_container: "#354479"
          property string primary_fixed: "#dce1ff"
          property string primary_fixed_dim: "#b6c4ff"
          property string scrim: "#000000"
          property string secondary: "#c2c5dd"
          property string secondary_container: "#424659"
          property string secondary_fixed: "#dee1f9"
          property string secondary_fixed_dim: "#c2c5dd"
          property string shadow: "#000000"
          property string surface: "#121318"
          property string surface_bright: "#38393f"
          property string surface_container: "#1e1f25"
          property string surface_container_high: "#292a2f"
          property string surface_container_highest: "#34343a"
          property string surface_container_low: "#1a1b21"
          property string surface_container_lowest: "#0d0e13"
          property string surface_dim: "#121318"
          property string surface_tint: "#b6c4ff"
          property string tertiary: "#e3bada"
          property string tertiary_container: "#5b3d57"
          property string tertiary_fixed: "#ffd7f5"
          property string tertiary_fixed_dim: "#e3bada"
        }
        property JsonObject light: JsonObject {
          id: light

          property string background: "#f4fafb"
          property string error: "#ba1a1a"
          property string error_container: "#ffdad6"
          property string inverse_on_surface: "#ecf2f2"
          property string inverse_primary: "#80d4da"
          property string inverse_surface: "#2b3232"
          property string on_background: "#161d1d"
          property string on_error: "#ffffff"
          property string on_error_container: "#410002"
          property string on_primary: "#ffffff"
          property string on_primary_container: "#002022"
          property string on_primary_fixed: "#002022"
          property string on_primary_fixed_variant: "#004f53"
          property string on_secondary: "#ffffff"
          property string on_secondary_container: "#041f21"
          property string on_secondary_fixed: "#041f21"
          property string on_secondary_fixed_variant: "#324b4d"
          property string on_surface: "#161d1d"
          property string on_surface_variant: "#3f4949"
          property string on_tertiary: "#ffffff"
          property string on_tertiary_container: "#091b36"
          property string on_tertiary_fixed: "#091b36"
          property string on_tertiary_fixed_variant: "#374764"
          property string outline: "#6f7979"
          property string outline_variant: "#bec8c9"
          property string primary: "#00696e"
          property string primary_container: "#9cf0f6"
          property string primary_fixed: "#9cf0f6"
          property string primary_fixed_dim: "#80d4da"
          property string scrim: "#000000"
          property string secondary: "#4a6365"
          property string secondary_container: "#cce8e9"
          property string secondary_fixed: "#cce8e9"
          property string secondary_fixed_dim: "#b1cccd"
          property string shadow: "#000000"
          property string source_color: "#478185"
          property string surface: "#f4fafb"
          property string surface_bright: "#f4fafb"
          property string surface_container: "#e9efef"
          property string surface_container_high: "#e3e9e9"
          property string surface_container_highest: "#dde4e4"
          property string surface_container_low: "#eff5f5"
          property string surface_container_lowest: "#ffffff"
          property string surface_dim: "#d5dbdb"
          property string surface_tint: "#00696e"
          property string surface_variant: "#dae4e5"
          property string tertiary: "#4e5f7d"
          property string tertiary_container: "#d6e3ff"
          property string tertiary_fixed: "#d6e3ff"
          property string tertiary_fixed_dim: "#b6c7e9"
        }
      }
    }
  }
}
