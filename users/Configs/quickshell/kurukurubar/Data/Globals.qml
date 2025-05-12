pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
  id: root
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

  // one of "COLLAPSED", "EXPANDED", "FULLY_EXPANDED"
  property string notchState: "COLLAPSED";
  property bool notchHovered: false;
  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  onActWinNameChanged: {
    if (root.actWinName == "desktop" && root.notchState == "COLLAPSED") {
      root.notchState = "EXPANDED"
    } else if (root.notchState == "EXPANDED" && !root.notchHovered) {
      root.notchState = "COLLAPSED"
    }
  }

  // Central Panel SwipeView stuff
  // 0 => Home
  // 1 => Calendar
  // 2 => System
  // 3 => Mpris
  // 4 => SettingsView
  property int swipeIndex: 0

  // SettingsView State
  // 0 => Power
  // 1 => Audio
  // 2 => Network
  property int settingsTabIndex: 0

  property string hostName: "KuruMi"
  Process {
    running: true
    command: ["hostname"]
    stdout: SplitParser {
      onRead: data => root.hostName = data
    }
  }
}
