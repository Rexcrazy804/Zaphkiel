pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../Data/" as Dat
import "../Generics/" as Gen

Rectangle {
  id: rect

  required property MprisPlayer player

  clip: true
  color: Dat.Colors.surface_container_low
  radius: 20

  Image {
    id: imgDisk

    anchors.horizontalCenter: rect.horizontalCenter
    fillMode: Image.PreserveAspectCrop
    height: this.width
    layer.enabled: true
    layer.smooth: true
    mipmap: true
    rotation: 0
    smooth: true
    source: player.trackArtUrl
    width: rect.width - 30
    y: 50

    layer.effect: MultiEffect {
      antialiasing: true
      maskEnabled: true
      maskSpreadAtMin: 1.0
      maskThresholdMax: 1.0
      maskThresholdMin: 0.5

      maskSource: Image {
        layer.smooth: true
        mipmap: true
        smooth: true
        source: "../Assets/discogs-svgrepo-com.svg"
      }
    }
    Behavior on rotation {
      NumberAnimation {
        duration: rotateTimer.interval
        easing.type: Easing.Linear
      }
    }
    Behavior on scale {
      NumberAnimation {
        duration: Dat.MaterialEasing.emphasizedTime
        easing.bezierCurve: Dat.MaterialEasing.emphasized
      }
    }
  }
  MouseArea {
    id: diskMouseArea

    anchors.bottom: rect.bottom
    anchors.left: rect.left
    anchors.right: rect.right

    // wonky but required
    height: rect.height * 0.40
    hoverEnabled: true

    onClicked: mevent => {
      rect.player.togglePlaying();
    }
    onEntered: {
      imgDisk.scale = 0.8;
    }
    onExited: {
      imgDisk.scale = 1;
    }
  }
  Timer {
    id: rotateTimer

    interval: 500
    repeat: true
    running: Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 3 && player.isPlaying

    onRunningChanged: {
      if (running) {
        imgDisk.rotation += 0.5;
      }
      // better hack to not wait for interval completion on quick state changes
    }
    onTriggered: imgDisk.rotation += 0.5
  }
  ColumnLayout {
    anchors.bottom: imgDisk.top
    anchors.bottomMargin: 5
    anchors.left: parent.left
    anchors.margins: 10
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: 0
    spacing: 0

    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredHeight: 2
      color: "transparent"

      Text {
        anchors.fill: parent
        color: Dat.Colors.on_surface
        elide: Text.ElideRight
        font.bold: true
        font.pointSize: 16
        horizontalAlignment: Text.AlignHCenter
        text: player.trackTitle
        verticalAlignment: Text.AlignBottom
      }
    }
    Rectangle {
      Layout.fillHeight: true
      Layout.fillWidth: true
      color: "transparent"

      Text {
        anchors.fill: parent
        color: Dat.Colors.on_surface
        elide: Text.ElideRight
        font.bold: true
        font.pointSize: 9
        horizontalAlignment: Text.AlignHCenter
        text: player.trackArtist
        verticalAlignment: Text.AlignTop
      }
    }
  }
  Rectangle {
    anchors.left: rect.left
    anchors.leftMargin: 20
    anchors.verticalCenter: rect.verticalCenter
    color: "transparent"
    height: 30
    width: 30

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.secondary
      font.bold: true
      font.pointSize: 16
      text: "󰒮"
    }
    Gen.MouseArea {
      anchors.fill: parent
      layerRadius: parent.width

      onClicked: {
        player.previous();
      }
    }
  }
  Rectangle {
    anchors.right: rect.right
    anchors.rightMargin: 20
    anchors.verticalCenter: rect.verticalCenter
    color: "transparent"
    height: 30
    width: 30

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.secondary
      font.bold: true
      font.pointSize: 16
      text: "󰒭"
    }
    Gen.MouseArea {
      anchors.fill: parent
      layerRadius: parent.width

      onClicked: {
        player.next();
      }
    }
  }

  // ColumnLayout {
  //   anchors.fill: parent
  //   anchors.margins: 5
  //   clip: true
  //
  //   ColumnLayout {
  //     Layout.fillHeight: true
  //     Layout.fillWidth: true
  //     Layout.preferredHeight: 2
  //     spacing: 0
  //
  //     Flickable {
  //       Layout.fillHeight: true
  //       Layout.fillWidth: true
  //       Layout.preferredHeight: 2
  //       // lets me centre short shit (and yes cent're', br'ish moment)
  //       contentWidth: (text.contentWidth > this.width) ? text.contentWidth : this.width
  //
  //       // contentX: (text.contentWidth > this.width)? (text.contentWidth / 2) : 0
  //
  //       Text {
  //         id: text
  //
  //         anchors.fill: parent
  //         color: "white"
  //         font.bold: true
  //         font.pointSize: 16
  //         horizontalAlignment: Text.AlignHCenter
  //         text: player.trackTitle
  //         verticalAlignment: Text.AlignBottom
  //         wrapMode: Text.NoWrap
  //       }
  //     }
  //     Text {
  //       Layout.fillHeight: true
  //       Layout.fillWidth: true
  //       Layout.preferredHeight: 1
  //       color: "white"
  //       font.pointSize: 9
  //       horizontalAlignment: Text.AlignHCenter
  //       text: player.trackArtist
  //       verticalAlignment: Text.AlignTop
  //     }
  //   }
  //
  //   // controlls
  //   RowLayout {
  //     Layout.fillHeight: true
  //     Layout.fillWidth: true
  //     // Layout.bottomMargin: 3
  //     Layout.leftMargin: 80
  //     Layout.preferredHeight: 1
  //     Layout.rightMargin: this.Layout.leftMargin
  //     spacing: 10
  //
  //     Rectangle {
  //       // Left
  //       Layout.fillHeight: true
  //       Layout.fillWidth: true
  //       color: "transparent"
  //
  //       Text {
  //         anchors.centerIn: parent
  //         color: "white"
  //         font.bold: true
  //         font.pointSize: 20
  //         text: "󰒮"
  //
  //         MouseArea {
  //           anchors.fill: parent
  //
  //           onClicked: {
  //             player.previous();
  //           }
  //         }
  //       }
  //     }
  //     Rectangle {
  //       // REsume/ Puase
  //       Layout.fillHeight: true
  //       Layout.fillWidth: true
  //       color: "transparent"
  //
  //       Text {
  //         anchors.centerIn: parent
  //         color: "white"
  //         font.bold: true
  //         font.pointSize: 20
  //         text: !(player.playbackState == MprisPlaybackState.Playing) ? "󰐊" : "󰏤"
  //
  //         MouseArea {
  //           anchors.fill: parent
  //
  //           onClicked: {
  //             player.togglePlaying();
  //           }
  //         }
  //       }
  //     }
  //     Rectangle {
  //       // Right NExt
  //       Layout.fillHeight: true
  //       Layout.fillWidth: true
  //       color: "transparent"
  //
  //     }
  //   }
  // }
}
