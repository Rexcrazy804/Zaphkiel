import QtQuick
import Quickshell
import QtQuick.Layouts
import "../Assets"
import "../Data"

Rectangle {
  id: root
  color: "transparent"
  property var wdata: Weather.weatherData

  border {
    color: Colors.tertiary
    width: 2
  }

  ColumnLayout {
    spacing: 0
    anchors.fill: parent

    Rectangle {
      color: "transparent"
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredHeight: 3

      Text {
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        color: Colors.primary
        text: (root.wdata?.current_condition?.[0].FeelsLikeC ?? "30") + "°C"
        font.pointSize: 32
      }
    }

    Rectangle {
      color: "transparent"
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredHeight: 2

      Text {
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        color: Colors.primary
        text: "creative block"
        font.pointSize: 14
      }
    }
  }
}
