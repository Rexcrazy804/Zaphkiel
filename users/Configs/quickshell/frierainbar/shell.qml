//@ pragma UseQApplication
import Quickshell
import QtQuick
import "Layers" as Lay
import "Data" as Dat

ShellRoot {
  Lay.Background {
  }

  Loader {
    active: Dat.Globals.bgState == "SHRUNK"

    sourceComponent: Lay.Top {
    }
  }

  Lay.Overlay {
  }

  // Lay.Bottom {}
  // Lay.PseudoTop {}

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
