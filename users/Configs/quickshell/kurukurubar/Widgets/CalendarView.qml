pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Data/" as Dat

Rectangle {
  property int index: SwipeView.index
  color: "transparent"

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10
    anchors.rightMargin: 5
    ColumnLayout { // Month display
      Layout.fillHeight: true
      Layout.minimumWidth: 30
      spacing: 0

      Rectangle { // Day display
        implicitHeight: 18
        Layout.fillWidth: true
        radius: 20
        bottomLeftRadius: 0
        bottomRightRadius: 0
        color: Dat.Colors.primary_container
        Text {
          id: weekDayText
          anchors.centerIn: parent
          text: Qt.formatDateTime(Dat.Clock?.date, "ddd")
          color: Dat.Colors.on_primary_container
          font.pointSize: 8
        }
      }

      Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: Dat.Colors.primary
        topLeftRadius: 0
        topRightRadius: 0
        radius: 10

        Text {
          rotation: -90
          anchors.centerIn: parent
          text: Qt.formatDateTime(Dat.Clock?.date, "MMM")
          color: Dat.Colors.on_primary
        }
      }
    }

    MonthGrid {
      id: monthGrid
      property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1
      property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))

      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 0
      // Layout.leftMargin: 50
      // Layout.rightMargin: this.Layout.leftMargin
      // color: Dat.Colors.surface_container
      // color: "transparent"

      delegate: Rectangle {
        required property var model
        color: (monthGrid.currDay == model.day)? Dat.Colors.primary : "transparent"
        radius: 10
        Text {
          anchors.centerIn: parent
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignVCenter
          text: parent.model.day
          color: (parent.model.month == monthGrid.currMonth)? (parent.model.day == monthGrid.currDay)? Dat.Colors.on_primary : Dat.Colors.on_surface : Dat.Colors.withAlpha(Dat.Colors.on_surface_variant, 0.70)
        }
      }
    }
  }
}
