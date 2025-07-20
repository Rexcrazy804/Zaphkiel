pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.Generics as Gen
import qs.Data as Dat
import qs.Widgets as Wid

Item {
  RowLayout {
    anchors.fill: parent
    spacing: 8

    Rectangle {
      // the page indicator
      Layout.leftMargin: 8
      color: Dat.Colors.surface_container_low
      implicitHeight: tabCols.height + 10
      implicitWidth: 28
      radius: 20

      ColumnLayout {
        id: tabCols

        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        width: parent.width

        Repeater {
          model: ["󰋜", "󰃭", "󱄅", "󰎇", "󰒓"]

          Item {
            id: tabDot

            required property int index
            required property string modelData

            Layout.alignment: Qt.AlignCenter
            implicitHeight: this.implicitWidth
            implicitWidth: 20

            Text {
              id: dotText

              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              font.pointSize: 11
              state: (swipeArea.currentIndex == tabDot.index) ? "ACTIVE" : "INACTIVE"
              text: tabDot.modelData

              states: [
                State {
                  name: "ACTIVE"

                  PropertyChanges {
                    dotText.scale: 1.6
                  }
                },
                State {
                  name: "INACTIVE"

                  PropertyChanges {
                    dotText.scale: 1
                  }
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
              layerRadius: parent.width
              layerRect.scale: dotText.scale

              onClicked: swipeArea.setCurrentIndex(tabDot.index)
            }
          }
        }
      }
    }

    Rectangle {
      id: swipeRect

      Layout.fillHeight: true
      Layout.fillWidth: true
      // Pages
      clip: true
      color: Dat.Colors.surface_container_low
      radius: 20

      SwipeView {
        id: swipeArea

        anchors.fill: parent
        orientation: Qt.Horizontal

        Component.onCompleted: () => {
          Dat.Globals.swipeIndexChanged.connect(() => {
            if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
              swipeArea.currentIndex = Dat.Globals.swipeIndex;
            }
          });

        // FOR DEBUGGING
        // swipeArea.currentIndex = 4;
        // Dat.Globals.settingsTabIndex = 2;
        // Dat.Globals.notchState = "FULLY_EXPANDED";
        }
        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex;
          }
        }

        Wid.HomeView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.CalendarView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.SystemView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.MusicView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.SettingsView {
          height: swipeRect.height
          width: swipeRect.width
        }
      }
    }
  }
}
