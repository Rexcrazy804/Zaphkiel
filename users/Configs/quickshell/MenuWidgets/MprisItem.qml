pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../Assets"

Rectangle {
  id: rect
  required property MprisPlayer player
  required property ListView view
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
      Layout.preferredHeight: 2
      spacing: 0

      Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 2
        // lets me centre short shit (and yes cent're', br'ish moment)
        contentWidth: (text.contentWidth > this.width)? text.contentWidth : this.width
        contentX: (text.contentWidth > this.width)? (text.contentWidth / 2) : 0

        Text {
          id: text
          anchors.fill: parent
          wrapMode: Text.NoWrap
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignBottom
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
        verticalAlignment: Text.AlignTop
        text: player.trackArtist
        font.pointSize: 9
      }
    }

    RowLayout {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 1
      Layout.leftMargin: 80
      Layout.rightMargin: this.Layout.leftMargin
      spacing: 10

      Rectangle {  // Left
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          color: Colors.primary
          anchors.centerIn: parent
          text: "󰒮"
          font.pointSize: 20
          font.bold: true

          MouseArea {
            anchors.fill: parent
            onClicked: {
              player.previous()
            }
          }
        }
      }
      Rectangle {  // REsume/ Puase
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          color: Colors.primary
          anchors.centerIn: parent
          text: !(player.playbackState == MprisPlaybackState.Playing)? "󰐊" : "󰏤"
          font.pointSize: 20
          font.bold: true

          MouseArea {
            anchors.fill: parent
            onClicked: {
              player.togglePlaying()
            }
          }
        }
      }
      Rectangle {  // Right NExt
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: "transparent"

        Text {
          color: Colors.primary
          anchors.centerIn: parent
          text: "󰒭"
          font.pointSize: 20
          font.bold: true

          MouseArea {
            anchors.fill: parent
            onClicked: {
              player.next()
            }
          }
        }
      }
    }

    RowLayout { // bottom buttons for switching players
      visible: rect.view.count > 1
      Layout.preferredHeight: 1
      Layout.bottomMargin: 2
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Repeater {
        model: rect.view.count
        Rectangle {
          id: playRect
          required property int index
          implicitWidth: (this.index == rect.index)? 8 : 6
          implicitHeight: this.implicitWidth

          color: (this.index == rect.index)? Colors.primary : Colors.withAlpha(Colors.primary, 0.79)

          MouseArea {
            anchors.fill: parent
            onClicked: () => {
              rect.view.positionViewAtIndex(playRect.index, ListView.Contain)
            }
          }
        }
      }
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

    value: rect.player.position
    from: 0
    to: rect.player.length

    FrameAnimation {
      running: rect.player.playbackState == MprisPlaybackState.Playing
      onTriggered: rect.player.positionChanged()
    }

    onMoved: { rect.player.position = slider.value }

    Component.onCompleted: {
      rect.player.positionChanged.connect(() => {
        slider.value = player.position
      })
    }
  }
}
