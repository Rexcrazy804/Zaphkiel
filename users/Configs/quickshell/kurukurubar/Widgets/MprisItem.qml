pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../Data/" as Dat

Rectangle {
  id: rect

  required property MprisPlayer player

  clip: true
  color: Dat.Colors.surface_container
  radius: 20

  Image {
    id: sourceItem

    fillMode: Image.PreserveAspectCrop
    anchors.fill: parent
    height: 300
    source: player.trackArtUrl
    visible: false
    width: 300
  }
  MultiEffect {
    anchors.fill: sourceItem
    maskEnabled: true
    maskSource: mask
    source: sourceItem
    brightness: -0.25
  }
  Item {
    id: mask
    height: sourceItem.height
    layer.enabled: true
    layer.smooth: true
    visible: false
    width: sourceItem.width

    Rectangle {
      height: sourceItem.height
      radius: 20
      width: sourceItem.width
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 5
    clip: true

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 2
      spacing: 0

      Flickable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        // lets me centre short shit (and yes cent're', br'ish moment)
        contentWidth: (text.contentWidth > this.width) ? text.contentWidth : this.width

        // contentX: (text.contentWidth > this.width)? (text.contentWidth / 2) : 0

        Text {
          id: text

          anchors.fill: parent
          color: "white"
          font.bold: true
          font.pointSize: 16
          horizontalAlignment: Text.AlignHCenter
          text: player.trackTitle
          verticalAlignment: Text.AlignBottom
          wrapMode: Text.NoWrap
        }
      }
      Text {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: "white"
        font.pointSize: 9
        horizontalAlignment: Text.AlignHCenter
        text: player.trackArtist
        verticalAlignment: Text.AlignTop
      }
    }

    // controlls
    RowLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      // Layout.bottomMargin: 3
      Layout.leftMargin: 80
      Layout.preferredHeight: 1
      Layout.rightMargin: this.Layout.leftMargin
      spacing: 10

      Rectangle {
        // Left
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          anchors.centerIn: parent
          color: "white"
          font.bold: true
          font.pointSize: 20
          text: "󰒮"

          MouseArea {
            anchors.fill: parent

            onClicked: {
              player.previous();
            }
          }
        }
      }
      Rectangle {
        // REsume/ Puase
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          anchors.centerIn: parent
          color: "white"
          font.bold: true
          font.pointSize: 20
          text: !(player.playbackState == MprisPlaybackState.Playing) ? "󰐊" : "󰏤"

          MouseArea {
            anchors.fill: parent

            onClicked: {
              player.togglePlaying();
            }
          }
        }
      }
      Rectangle {
        // Right NExt
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          anchors.centerIn: parent
          color: "white"
          font.bold: true
          font.pointSize: 20
          text: "󰒭"

          MouseArea {
            anchors.fill: parent

            onClicked: {
              player.next();
            }
          }
        }
      }
    }
  }
}
