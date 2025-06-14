pragma Singleton
import Quickshell
import QtQuick

SystemClock {
  id: clock

  enabled: Globals.notchState != "COLLAPSED"
  precision: SystemClock.Seconds
}
