//@ pragma UseQApplication
import Quickshell
import QtQuick
import "Layers" as Lay

ShellRoot {
  Lay.Background {}
  // Lay.Bottom {}
  // Lay.PseudoTop {}
  // Lay.Top {}

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
