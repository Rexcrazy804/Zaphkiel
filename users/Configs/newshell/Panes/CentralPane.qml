import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Assets/" as Ass
import "../Generics/" as Gen
import "../Data/" as Dat
import "../Widgets/" as Wid

import QtQuick

Rectangle {
  id: root

  color: "transparent"
  RowLayout {
    anchors.fill: parent
    spacing: 8
    layoutDirection: Qt.RightToLeft

    Rectangle { // Pages
      clip: true
      id: swipeRect
      Layout.fillWidth: true
      Layout.fillHeight: true

      color: Ass.Colors.surface_container_low
      radius: root.radius

      SwipeView {
        id: swipeArea
        anchors.fill: parent
        orientation: Qt.Horizontal

        // for debugging
        Component.onCompleted: () => {
          swipeArea.currentIndex = 1;
          Dat.Globals.notchState = "FULLY_EXPANDED"
        }

        Rectangle { // HOME PANE ??? WHAT TO DO HERE?
          property int index: SwipeView.index
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
          // color: Ass.Colors.surface_container
          color: "transparent"

          Text {
            anchors.centerIn: parent
            text: "Pane " + parent.index + " Home"
            color: Ass.Colors.on_surface
          }
        }

        Wid.CalendarView {
          width: swipeRect.width
          height: swipeRect.height
          radius: swipeRect.radius
        }

        // TODO PANES:
        // nix pane (sys info and shit maybe???)
        // mpris pane
        // toggles pane
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

        Repeater {
          model: ["󰋜", "󰃭", "󱄅", "󰎇", "󰒓"]
          Rectangle {
            id: tabDot
            required property string modelData
            Layout.alignment: Qt.AlignCenter
            radius: 20
            width: 20
            height: 20
            color: Ass.Colors.surface_container_high

            Text {
              color: Ass.Colors.on_surface
              anchors.centerIn: parent
              text: tabDot.modelData
            }

            Gen.MouseArea {}
          }
        }
      }
    }
  }
}
