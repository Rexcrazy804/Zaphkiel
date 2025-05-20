import Quickshell
import QtQuick
import "Panes" as Panes
import "Data" as Dat

ShellRoot {
  // uncomment this if you want to reserve space for the notch
  // Panes.PseudoReserved {}
  // Component.onCompleted: {
  //   Dat.Globals.reservedShell = true
  // }

  Panes.Notch {
  }

  // inhibit the reload popup
  Connections {
    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
    }
    function onReloadFailed() {
      Quickshell.inhibitReloadPopup();
    }

    target: Quickshell
  }
}
