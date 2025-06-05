pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: root
  color: "transparent"

  // 🔧 Responsive scaling factor
  property real scaleFactor: Math.min(Screen.width, Screen.height) / 750

  RowLayout {
    anchors.fill: parent
    layoutDirection: Qt.RightToLeft
    spacing: 8 * scaleFactor

    Rectangle {
      id: swipeRect

      Layout.fillHeight: true
      Layout.fillWidth: true
      clip: true
      color: Dat.Colors.surface_container_low
      radius: 20 * scaleFactor

      SwipeView {
        id: swipeArea
        anchors.fill: parent
        orientation: Qt.Horizontal

        Component.onCompleted: () => {
          Dat.Globals.swipeIndexChanged.connect(() => {
            if (swipeArea.currentIndex !== Dat.Globals.swipeIndex) {
              swipeArea.currentIndex = Dat.Globals.swipeIndex;
            }
          });
        }

        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex !== Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex;
          }
        }

        // 📱 Views inside SwipeView
        Wid.HomeView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }

        Wid.CalendarView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }

        Wid.SystemView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }

        Wid.MusicView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }

        Wid.SettingsView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }
      }
    }

    Rectangle {
      // ◉ Page Indicator
      Layout.leftMargin: 8 * scaleFactor
      color: Dat.Colors.surface_container_low
      implicitWidth: 28 * scaleFactor
      implicitHeight: tabCols.height + 0.1 * scaleFactor
      radius: 20 * scaleFactor

      ColumnLayout {
        id: tabCols
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10 * scaleFactor
        width: parent.width

        Repeater {
          model: ["󰋜", "󰃭", "󱄅", "󰎇", "󰒓"]

          Rectangle {
            id: tabDot

            required property int index
            required property string modelData

            Layout.alignment: Qt.AlignCenter
            color: "transparent"
            implicitWidth: 20 * scaleFactor
            implicitHeight: 20 * scaleFactor
            radius: 10 * scaleFactor

            Text {
              id: dotText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              font.pointSize: 11 * scaleFactor
              text: tabDot.modelData
              state: (swipeArea.currentIndex === tabDot.index) ? "ACTIVE" : "INACTIVE"

              states: [
                State {
                  name: "ACTIVE"
                  PropertyChanges { dotText.scale: 1.6 }
                },
                State {
                  name: "INACTIVE"
                  PropertyChanges { dotText.scale: 1 }
                }
              ]

              transitions: [
                Transition {
                  from: "INACTIVE"
                  to: "ACTIVE"
                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardAccelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    property: "scale"
                  }
                },
                Transition {
                  from: "ACTIVE"
                  to: "INACTIVE"
                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardDecelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardDecel
                    property: "scale"
                  }
                }
              ]
            }

            Gen.MouseArea {
              layerRect.scale: dotText.scale
              onClicked: swipeArea.setCurrentIndex(tabDot.index)
            }
          }
        }
      }
    }
  }
}
