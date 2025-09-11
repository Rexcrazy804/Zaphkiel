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
    path: Dat.Paths.config + "/colors.json"
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

          readonly property string background: "#121318"
          readonly property string error: "#ffb4ab"
          readonly property string error_container: "#93000a"
          readonly property string inverse_on_surface: "#2f3036"
          readonly property string inverse_primary: "#4d5c92"
          readonly property string inverse_surface: "#e3e1e9"
          readonly property string on_background: "#e3e1e9"
          readonly property string on_error: "#690005"
          readonly property string on_error_container: "#ffdad6"
          readonly property string on_primary: "#1d2d61"
          readonly property string on_primary_container: "#dce1ff"
          readonly property string on_primary_fixed: "#04174b"
          readonly property string on_primary_fixed_variant: "#354479"
          readonly property string on_secondary: "#2b3042"
          readonly property string on_secondary_container: "#dee1f9"
          readonly property string on_secondary_fixed: "#161b2c"
          readonly property string on_secondary_fixed_variant: "#424659"
          readonly property string on_surface: "#e3e1e9"
          readonly property string on_surface_variant: "#c6c5d0"
          readonly property string on_tertiary: "#432740"
          readonly property string on_tertiary_container: "#ffd7f5"
          readonly property string on_tertiary_fixed: "#2c122a"
          readonly property string on_tertiary_fixed_variant: "#5b3d57"
          readonly property string outline: "#90909a"
          readonly property string outline_variant: "#45464f"
          readonly property string primary: "#b6c4ff"
          readonly property string primary_container: "#354479"
          readonly property string primary_fixed: "#dce1ff"
          readonly property string primary_fixed_dim: "#b6c4ff"
          readonly property string scrim: "#000000"
          readonly property string secondary: "#c2c5dd"
          readonly property string secondary_container: "#424659"
          readonly property string secondary_fixed: "#dee1f9"
          readonly property string secondary_fixed_dim: "#c2c5dd"
          readonly property string shadow: "#000000"
          readonly property string surface: "#121318"
          readonly property string surface_bright: "#38393f"
          readonly property string surface_container: "#1e1f25"
          readonly property string surface_container_high: "#292a2f"
          readonly property string surface_container_highest: "#34343a"
          readonly property string surface_container_low: "#1a1b21"
          readonly property string surface_container_lowest: "#0d0e13"
          readonly property string surface_dim: "#121318"
          readonly property string surface_tint: "#b6c4ff"
          readonly property string tertiary: "#e3bada"
          readonly property string tertiary_container: "#5b3d57"
          readonly property string tertiary_fixed: "#ffd7f5"
          readonly property string tertiary_fixed_dim: "#e3bada"
        }
        property JsonObject light: JsonObject {
          id: light

          readonly property string background: "#f4fafb"
          readonly property string error: "#ba1a1a"
          readonly property string error_container: "#ffdad6"
          readonly property string inverse_on_surface: "#ecf2f2"
          readonly property string inverse_primary: "#80d4da"
          readonly property string inverse_surface: "#2b3232"
          readonly property string on_background: "#161d1d"
          readonly property string on_error: "#ffffff"
          readonly property string on_error_container: "#410002"
          readonly property string on_primary: "#ffffff"
          readonly property string on_primary_container: "#002022"
          readonly property string on_primary_fixed: "#002022"
          readonly property string on_primary_fixed_variant: "#004f53"
          readonly property string on_secondary: "#ffffff"
          readonly property string on_secondary_container: "#041f21"
          readonly property string on_secondary_fixed: "#041f21"
          readonly property string on_secondary_fixed_variant: "#324b4d"
          readonly property string on_surface: "#161d1d"
          readonly property string on_surface_variant: "#3f4949"
          readonly property string on_tertiary: "#ffffff"
          readonly property string on_tertiary_container: "#091b36"
          readonly property string on_tertiary_fixed: "#091b36"
          readonly property string on_tertiary_fixed_variant: "#374764"
          readonly property string outline: "#6f7979"
          readonly property string outline_variant: "#bec8c9"
          readonly property string primary: "#00696e"
          readonly property string primary_container: "#9cf0f6"
          readonly property string primary_fixed: "#9cf0f6"
          readonly property string primary_fixed_dim: "#80d4da"
          readonly property string scrim: "#000000"
          readonly property string secondary: "#4a6365"
          readonly property string secondary_container: "#cce8e9"
          readonly property string secondary_fixed: "#cce8e9"
          readonly property string secondary_fixed_dim: "#b1cccd"
          readonly property string shadow: "#000000"
          readonly property string source_color: "#478185"
          readonly property string surface: "#f4fafb"
          readonly property string surface_bright: "#f4fafb"
          readonly property string surface_container: "#e9efef"
          readonly property string surface_container_high: "#e3e9e9"
          readonly property string surface_container_highest: "#dde4e4"
          readonly property string surface_container_low: "#eff5f5"
          readonly property string surface_container_lowest: "#ffffff"
          readonly property string surface_dim: "#d5dbdb"
          readonly property string surface_tint: "#00696e"
          readonly property string surface_variant: "#dae4e5"
          readonly property string tertiary: "#4e5f7d"
          readonly property string tertiary_container: "#d6e3ff"
          readonly property string tertiary_fixed: "#d6e3ff"
          readonly property string tertiary_fixed_dim: "#b6c7e9"
        }
      }
    }
  }
}
