pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.Layers as Lay
import qs.Data as Dat

ShellRoot {
  Variants {
    model: Quickshell.screens

    Scope {
      id: scopeRoot

      required property ShellScreen modelData

      LazyLoader {
        activeAsync: Dat.Config.data.reservedShell

        component: Lay.PseudoReserved {
          modelData: scopeRoot.modelData
        }
      }

      LazyLoader {
        activeAsync: Dat.Config.data.setWallpaper

        component: Lay.Wallpaper {
          modelData: scopeRoot.modelData
        }
      }

      LazyLoader {
        activeAsync: Dat.Config.data.mousePsystem

        component: Lay.MouseParticles {
          modelData: scopeRoot.modelData
        }
      }

      Lay.Notch {
        modelData: scopeRoot.modelData
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
  }

  Lay.LockScreen {
  }
}
