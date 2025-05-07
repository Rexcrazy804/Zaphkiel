pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  // one of "COLLAPSED", "EXPANDED", "FULLY_EXPANDED"
  property string notchState: "COLLAPSED";
}
