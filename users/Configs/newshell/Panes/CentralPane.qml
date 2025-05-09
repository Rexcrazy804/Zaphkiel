pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Assets/" as Ass
import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

Rectangle {
  id: root

  color: "transparent"
  RowLayout {
    anchors.fill: parent
    spacing: 8
    layoutDirection: Qt.RightToLeft

    Rectangle {
      id: swipeRect
      // Pages
      clip: true
      Layout.fillWidth: true
      Layout.fillHeight: true

      color: Ass.Colors.surface_container_low
      radius: root.radius

      SwipeView {
        id: swipeArea
        anchors.fill: parent
        orientation: Qt.Horizontal

        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex
          }
        }

        Component.onCompleted: () => {
          Dat.Globals.swipeIndexChanged.connect(() => {
            if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
              swipeArea.currentIndex = Dat.Globals.swipeIndex
            }
          })
          // both are zero at the beginning sooo dk if I need this
          swipeArea.currentIndex = Dat.Globals.swipeIndex;

          // FOR DEBUGGING
          swipeArea.currentIndex = 4;
          Dat.Globals.notchState = "FULLY_EXPANDED";
        }


        Rectangle {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
          color: "transparent"

          Text {
            anchors.centerIn: parent
            text: "Home pane"
            color: Ass.Colors.on_surface
          }
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

        Rectangle {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
          color: "transparent"

          Text {
            anchors.centerIn: parent
            text: "Music Pane"
            color: Ass.Colors.on_surface
          }
        }

        Wid.SettingsView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }
      }
    }

    Rectangle {
      // the page indicator
      Layout.leftMargin: 8
      radius: 20
      implicitHeight: tabCols.height + 10
      implicitWidth: 28
      color: Ass.Colors.surface_container_low

      ColumnLayout {
        id: tabCols
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Repeater {
          model: ["󰋜", "󰃭", "󱄅", "󰎇", "󰒓"]
          Rectangle {
            id: tabDot
            required property string modelData
            required property int index

            Layout.alignment: Qt.AlignCenter
            radius: 20
            implicitWidth: 20
            implicitHeight: this.implicitWidth
            color: "transparent"
            Text {
              id: dotText
              color: Ass.Colors.on_surface
              anchors.centerIn: parent
              text: tabDot.modelData
              font.pointSize: 11

              state: (swipeArea.currentIndex == tabDot.index) ? "ACTIVE" : "INACTIVE"
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
                    property: "scale"
                    duration: Dat.MaterialEasing.standardAccelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  }
                },
                Transition {
                  from: "ACTIVE"
                  to: "INACTIVE"
                  NumberAnimation {
                    property: "scale"
                    duration: Dat.MaterialEasing.standardDecelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardDecel
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
