pragma Singleton
import QtQuick
import QtQuick.Particles
import Quickshell
import QtQuick.Controls
import Quickshell.Wayland

Singleton {
  id: root

  property string actWinName: activeWindow?.activated ? activeWindow?.appId : "desktop"
  readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

  // [ "SRHUNK" "FILLED" ]
  property string bgState: "FILLED"
  property StackView stack
  property ParticleSystem pSys
}
