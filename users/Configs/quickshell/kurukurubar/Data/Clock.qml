pragma Singleton
import Quickshell
import QtQuick

SystemClock {
  id: clock
  precision: SystemClock.Seconds
  enabled: Globals.notchState != "COLLAPSED"
}
