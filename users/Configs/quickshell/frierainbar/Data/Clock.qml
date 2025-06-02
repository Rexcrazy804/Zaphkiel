pragma Singleton
import Quickshell
import QtQuick

SystemClock {
  id: clock

  enabled: Globals.bgState == "SHRUNK"
  precision: SystemClock.Seconds
}
