pragma Singleton
import QtQuick
import Quickshell
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
  property int swipeIndex: 0
}
