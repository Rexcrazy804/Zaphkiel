import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.Data as Dat

Item {
  property int index: SwipeView.index

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10
    anchors.rightMargin: 5

    ColumnLayout {
      // Month display
      Layout.fillHeight: true
      Layout.minimumWidth: 30
      spacing: 0

      Rectangle {
        Layout.fillWidth: true
        bottomLeftRadius: 0
        bottomRightRadius: 0
        color: Dat.Colors.primary_container
        // Day display
        implicitHeight: 18
        radius: 20

        Text {
          id: weekDayText

          anchors.centerIn: parent
          color: Dat.Colors.on_primary_container
          font.pointSize: 8
          text: Qt.formatDateTime(Dat.Clock?.date, "ddd")
        }
      }

      Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: Dat.Colors.primary
        radius: 10
        topLeftRadius: 0
        topRightRadius: 0

        Text {
          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          rotation: -90
          text: Qt.formatDateTime(Dat.Clock?.date, "MMMM")
        }
      }
    }

    MonthGrid {
      id: monthGrid

      property int currDay: parseInt(Qt.formatDateTime(Dat.Clock?.date, "d"))
      property int currMonth: parseInt(Qt.formatDateTime(Dat.Clock?.date, "M")) - 1

      Layout.fillHeight: true
      Layout.fillWidth: true
      spacing: 0

      // Layout.leftMargin: 50
      // Layout.rightMargin: this.Layout.leftMargin
      // color: Dat.Colors.surface_container
      // color: "transparent"

      delegate: Item {
        required property var model

        Rectangle {
          anchors.centerIn: parent
          color: (monthGrid.currDay == model.day && monthGrid.currMonth == model.month) ? Dat.Colors.primary : "transparent"
          height: parent.height
          radius: 6
          width: this.height
        }

        Text {
          anchors.centerIn: parent
          color: (parent.model.month == monthGrid.currMonth) ? (parent.model.day == monthGrid.currDay) ? Dat.Colors.on_primary : Dat.Colors.on_surface : Dat.Colors.withAlpha(Dat.Colors.on_surface_variant, 0.70)
          font.pointSize: 10
          text: parent.model.day
        }
      }
    }
  }
}
