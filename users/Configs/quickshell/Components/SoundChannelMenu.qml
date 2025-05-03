import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland

import "../Assets"
import "../Data"

PopupWindow {
  id: panel
  required property PanelWindow bar

  visible: false
  color: "transparent"
  anchor.window: bar
  anchor.rect.x: bar.width - width - 10
  anchor.rect.y: bar.height + 10
  width: 400
  height: 200

  HyprlandFocusGrab {
    id: grab
    windows: [ panel ]

    onActiveChanged: { 
      if (!grab.active) {
        panel.visible = false
      }
    }
  }

  onVisibleChanged: {
    if (visible) {
      grab.active = true
    }
  }

  Rectangle {
    color: Colors.withAlpha(Colors.surface, 0.79)
    anchors.centerIn: parent
    width: parent.width - 10
    height: parent.height - 10
    border {
      color: Colors.primary
      width: 2
    }


    ListView {
      id: list
      anchors.fill: parent
      anchors.margins: 10
      anchors.topMargin: 26
      anchors.bottomMargin: 10
      clip: true
      spacing: 14

      model: ScriptModel {
        id: script
        values: Pipewire.nodes.values.filter(node => node.audio != null && !node.description.startsWith("Tiger"))
      }

      delegate: Slider {
        required property PwNode modelData
        required property int index
        id: slider
        width: parent.width
        height: 30
        snapMode: Slider.NoSnap

        PwObjectTracker { objects: [ modelData ] }

        background: Rectangle {
          id: sliderback
          anchors.centerIn: parent
          color: Colors.on_primary
          height: slider.height
          width: slider.availableWidth
          Layout.alignment: Qt.AlignTop
          clip: true


          Rectangle {
            color: Colors.primary
            width: slider.visualPosition * slider.availableWidth
            height: slider.height
          }

          Text {
            id: text
            property string icon: (!modelData?.isSink)? "󰕾 " : "󰍬 "
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            color: Colors.on_primary
            font.bold: true
            text: text.icon + ((slider.modelData?.description == "")? slider.modelData?.name : slider.modelData?.description)
          }
        }

        handle: Rectangle {
          visible: false
        }
        value: slider.modelData?.audio?.volume * 100
        from: 0
        to: 100

        onValueChanged: {
          slider.modelData.audio.volume = (slider.value / 100)
        }
      }
    }

    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.topMargin: -5
      anchors.leftMargin: -5
      height: headerText.height + 5
      width: headerText.width + 10
      color: Colors.primary

      Text {
        anchors.centerIn: parent
        id: headerText
        text: "Audio"
        color: Colors.on_primary
      }
    }

    Text {
      visible: script.values.length == 0
      anchors.centerIn: parent
      text: "No Active Audio Channels"
      color: Colors.primary
      font.pointSize: 16
    }
  }

}

