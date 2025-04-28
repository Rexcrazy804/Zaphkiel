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

  visible: true
  color: "transparent"
  anchor.window: bar
  anchor.rect.x: bar.width - width - 10
  anchor.rect.y: bar.height + 10
  width: 400
  height: 300

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
      color: Colors.secondary
      width: 2
    }

    ListView {
      anchors.fill: parent
      anchors.margins: 10
      anchors.topMargin: 30
      anchors.bottomMargin: 10
      clip: true
      spacing: 14

      model: ListModel {
        property var pipe: Pipewire
        property list<PwNode> nodes: Pipewire.nodes.values
        id: data

        function update() {
            for (var i = 0; i < nodes.length; i++) {
              if (nodes[i].audio != null) {
                data.insert(0, {data: data.nodes[i]})
              }
            }
        }
        Component.onCompleted: {
          pipe.onReadyChanged.connect(() => update())
          if (pipe.ready) { update() }
        }
      }
      delegate: Slider {
        required property PwNode modelData
        required property int index
        id: slider
        width: parent.width
        height: 30
        snapMode: Slider.noSnap

        PwObjectTracker { objects: [ modelData ] }

        background: Rectangle {
          id: sliderback
          anchors.centerIn: parent
          color: Colors.on_secondary
          height: slider.height
          width: slider.availableWidth
          Layout.alignment: Qt.AlignTop
          clip: true

          Rectangle {
            color: Colors.secondary
            width: slider.visualPosition * slider.availableWidth
            height: slider.height

            Text {
              anchors.centerIn: parent
              color: Colors.on_secondary
              text: slider.modelData?.properties["application.process.binary"]
              font.bold: true
            }
          }
        }

        handle: Rectangle {
          visible: false
        }
        value: slider.modelData?.audio?.volume * 100
        from: 0
        to: 100

        Component.onCompleted: {
          console.log(slider.modelData.name)
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
      color: Colors.secondary

      Text {
        anchors.centerIn: parent
        id: headerText
        text: "Audio"
        color: Colors.on_secondary
      }
    }
  }

}

