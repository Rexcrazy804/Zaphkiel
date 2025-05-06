pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Wayland

Singleton {
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
  readonly property real hasActiveWindow: (activeWindow?.activated)? true : false
}
