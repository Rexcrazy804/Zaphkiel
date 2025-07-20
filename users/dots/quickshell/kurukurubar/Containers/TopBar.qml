import QtQuick
import QtQuick.Layouts

import qs.Data as Dat
import qs.Widgets as Wid

RowLayout {
  // Left
  Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    RowLayout {
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter

      Wid.WorkspacePill {
        Layout.leftMargin: 5
      }

      Wid.MprisDot {
        implicitHeight: 20
        implicitWidth: 20
        radius: 20
      }

      Wid.RecordingDot {
        implicitHeight: 20
        implicitWidth: 20
      }
    }
  }

  // Center
  Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    Wid.TimePill {
    }
  }

  // Right
  Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    RowLayout {
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.top: parent.top
      layoutDirection: Qt.RightToLeft
      spacing: 8

      Text {
        Layout.fillWidth: false
        // little arrow to toggle notch expand states
        Layout.rightMargin: 5
        color: Dat.Colors.primary
        font.pointSize: 11
        text: (Dat.Globals.notchState == "FULLY_EXPANDED") ? "" : ""
        verticalAlignment: Text.AlignVCenter

        MouseArea {
          anchors.fill: parent

          onClicked: mevent => {
            if (Dat.Globals.notchState == "EXPANDED") {
              Dat.Globals.notchState = "FULLY_EXPANDED";
              return;
            }

            Dat.Globals.notchState = "EXPANDED";
          }
        }
      }

      Wid.BatteryPill {
        implicitHeight: 20
        radius: 20
      }

      Wid.AudioSwiper {
        implicitHeight: 20
        radius: 20
      }

      Wid.BrightnessDot {
        implicitHeight: 20
        implicitWidth: 20
        radius: 20
      }
    }
  }
}
