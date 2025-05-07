import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import "../Assets/" as Ass
import "../Data/" as Dat
import "../Generics/" as Gen
import "../Widgets/" as Wid

ClippingRectangle {
  clip: true
  radius: 20
  color: Ass.Colors.withAlpha(Ass.Colors.surface, 0.9)

  RowLayout {
    anchors.fill: parent
    spacing: 2
    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.minimumWidth: 28
      Layout.maximumWidth: 28
      Layout.alignment: Qt.AlignCenter
      Layout.leftMargin: 5
      Layout.rightMargin: -5

      Wid.SessionDots {}
    }
    Rectangle { // Left Side Card Stuff (not kuru kuru)
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      radius: 20
      color: Ass.Colors.surface_container
      RowLayout {
        anchors.fill: parent

        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          color: "transparent"
          radius: 20
        }
      }
    }
    Rectangle {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredWidth: 1
      radius: 20
      color: "transparent"

      RowLayout {
        anchors.fill: parent
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredWidth: 1.45
          color: "transparent"
          Text {
            color: Ass.Colors.secondary
            anchors.centerIn: parent
            text: " Kuru Kuru Kuru"
          }
        }
        AnimatedImage {
          playing: parent.visible
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredWidth: 1

          fillMode: Image.PreserveAspectCrop
          horizontalAlignment: Image.AlignRight
          source: "https://duiqt.github.io/herta_kuru/static/img/hertaa1.gif"
        }
      }
    }
  }
}
