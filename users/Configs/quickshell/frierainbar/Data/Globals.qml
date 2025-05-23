pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
  id: root
  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
  property string bgState: "SHRUNK"
}
