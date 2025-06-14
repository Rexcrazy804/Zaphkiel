import Quickshell
import QtQuick
import "Panes" as Panes
import "Data" as Dat

ShellRoot {
  Loader {
    active: Dat.Config.data.reservedShell

    sourceComponent: Panes.PseudoReserved {
    }
  }

  Loader {
    active: Dat.Config.data.mousePsystem

    sourceComponent: Panes.BottomLayer {
    }
  }

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
