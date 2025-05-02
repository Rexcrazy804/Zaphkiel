import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "../Assets"

Rectangle {
  id: rect
  required property MprisPlayer player
  color: "transparent"

  Image {
    id: albumArt
    anchors.fill: parent
    source: rect.player.trackArtUrl
    fillMode: Image.PreserveAspectCrop
    retainWhileLoading: true
  }

  MultiEffect {
    source: albumArt
    anchors.fill: albumArt
    blurEnabled: true
    blur: 0.4
    brightness: -0.3
  }

  ColumnLayout {
    clip: true
    anchors.fill: parent
    anchors.margins: 5

    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredHeight: 1
      spacing: 2

      Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 2
        // lets me centre short shit (and yes cent're', br'ish moment)
        contentWidth: (text.contentWidth > this.width)? text.contentWidth : this.width
        contentX: (text.contentWidth > this.width)? contentWidth / 2 : 0

        Text {
          id: text
          anchors.fill: parent
          wrapMode: Text.NoWrap
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
          color: "white"
          text: player.trackTitle
          font.pointSize: 16
          font.bold: true
        }
      }
      Text {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 1
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: player.trackArtist
        font.pointSize: 9
      }
    }

    ColumnLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 1

      Rectangle { 
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"
      }

    }

    RowLayout { // bottom buttons for switching players
      Layout.preferredHeight: 0.2
      Layout.fillHeight: true
      Layout.fillWidth: true
      // border.color: "White"
      // color: "transparent"
    }
  }
  Slider { 
    id: slider
    anchors.bottom: rect.bottom
    anchors.left: rect.left
    anchors.right: rect.right

    height: 2

    padding: 0
    topInset: 0
    bottomInset: 0
    rightInset: 0
    leftInset: 0
    snapMode: Slider.NoSnap

    background: Rectangle {
      id: sliderback
      anchors.fill: slider
      color: Colors.withAlpha(Colors.primary_container, 0.79)
      height: slider.height
      width: slider.availableWidth

      Rectangle {
        color: Colors.primary
        width: slider.visualPosition * slider.availableWidth
        height: slider.height
      }
    }
    handle: Rectangle {visible: false}

    value: player.position
    from: 0
    to: player.length

    FrameAnimation {
      running: player.playbackState == MprisPlaybackState.Playing
      onTriggered: player.positionChanged()
    }

    onMoved: { player.position = slider.value }

    Component.onCompleted: {
      player.positionChanged.connect(() => {
        slider.value = player.position
      })
    }
  }
}
