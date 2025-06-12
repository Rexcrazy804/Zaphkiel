pragma Singleton
import Quickshell
import Qt.labs.platform

Singleton {
  // refer https://doc.qt.io/qt-6/qstandardpaths.html#StandardLocation-enum
  // god fucking knows how soramane found this
  readonly property url cache: `${StandardPaths.standardLocations(StandardPaths.GenericCacheLocation)[0]}/kurukurubar`
  readonly property url config: `${StandardPaths.standardLocations(StandardPaths.GenericConfigLocation)[0]}/kurukurubar`
}
