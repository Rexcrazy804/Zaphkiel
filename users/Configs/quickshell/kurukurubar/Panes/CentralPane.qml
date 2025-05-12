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

  RowLayout {
    anchors.fill: parent
    layoutDirection: Qt.RightToLeft
    spacing: 8

    Rectangle {
      id: swipeRect

      Layout.fillHeight: true
      Layout.fillWidth: true
      // Pages
      clip: true
      color: Dat.Colors.surface_container_low
      radius: root.radius

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
          // both are zero at the beginning sooo dk if I need this
          swipeArea.currentIndex = Dat.Globals.swipeIndex;

          // FOR DEBUGGING
          swipeArea.currentIndex = 1;
          Dat.Globals.notchState = "FULLY_EXPANDED";
        }
        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex;
          }
        }

        Rectangle {
          color: "transparent"
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            text: "Home pane"
          }
        }
        Wid.CalendarView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }
        Wid.SystemView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }
        Rectangle {
          color: "transparent"
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width

          Text {
            anchors.centerIn: parent
            color: Dat.Colors.on_surface
            text: "Music Pane"
          }
        }
        Wid.SettingsView {
          height: swipeRect.height
          radius: swipeRect.radius
          width: swipeRect.width
        }
      }
    }
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

          Rectangle {
            id: tabDot

            required property int index
            required property string modelData

            Layout.alignment: Qt.AlignCenter
            color: "transparent"
            implicitHeight: this.implicitWidth
            implicitWidth: 20
            radius: 20

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
              onClicked: swipeArea.setCurrentIndex(tabDot.index)
            }
          }
        }
      }
    }
  }
}
