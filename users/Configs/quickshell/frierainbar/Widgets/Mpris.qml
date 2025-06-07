import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Mpris

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  Rectangle {
    anchors.fill: parent
    color: Dat.Colors.surface_container_high
    radius: 20
  }

  Text {
    anchors.centerIn: parent
    color: Dat.Colors.primary
    font.family: Dat.Fonts.hurricane
    font.pointSize: 32
    text: "Play Some Music"
    visible: Mpris.players.values.length == 0

    AnimatedImage {
      anchors.centerIn: parent
      fillMode: AnimatedImage.PreserveAspectFit
      height: this.width
      playing: parent.visible
      source: "https://media.tenor.com/tPfCnUEDWMQAAAAi/frieren-frieren-dance.gif"
      width: 130
    }
  }

  SwipeView {
    anchors.fill: parent

    Repeater {
      delegate: _mprisItem
      model: Mpris.players
    }
  }

  Component {
    id: _mprisItem

    Item {
      id: mprisItem

      required property MprisPlayer modelData

      height: parent.height
      width: parent.width

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: controls.state = "REVEALED"
        onClicked: controls.state = (controls.state == "REVEALED")? "HIDDEN" : "REVEALED"

        Component.onCompleted: {
          Dat.Globals.bgStateChanged.connect(() => {
            if (Dat.Globals.bgState == "FILLED") {
              controls.state = "HIDDEN"
            }
          })
        }

        ColumnLayout {
          anchors.fill: parent
          spacing: 0

          Item {
            id: controls

            Layout.fillWidth: true
            state: "HIDDEN"

            states: [
              State {
                name: "HIDDEN"

                PropertyChanges {
                  controls.implicitHeight: 0
                  controls.visible: false
                  playPauseIcon.opacity: 0
                }
              },
              State {
                name: "REVEALED"

                PropertyChanges {
                  controls.implicitHeight: 60
                  controls.visible: true
                  playPauseIcon.opacity: 1
                }
              }
            ]
            transitions: [
              Transition {
                from: "HIDDEN"
                to: "REVEALED"

                SequentialAnimation {
                  PropertyAction {
                    property: "visible"
                  }

                  ParallelAnimation {
                    NumberAnimation {
                      duration: Dat.MaterialEasing.emphasizedTime * 1.5
                      easing.bezierCurve: Dat.MaterialEasing.emphasized
                      property: "implicitHeight"
                    }

                    NumberAnimation {
                      duration: Dat.MaterialEasing.standardTime
                      easing.type: Easing.Linear
                      property: "opacity"
                      target: playPauseIcon
                    }
                  }
                }
              },
              Transition {
                from: "REVEALED"
                to: "HIDDEN"

                SequentialAnimation {
                  ParallelAnimation {
                    NumberAnimation {
                      duration: Dat.MaterialEasing.standardAccelTime
                      easing.type: Easing.Linear
                      property: "opacity"
                      target: playPauseIcon
                    }

                    NumberAnimation {
                      duration: Dat.MaterialEasing.emphasizedTime
                      easing.bezierCurve: Dat.MaterialEasing.emphasized
                      property: "implicitHeight"
                    }
                  }

                  PropertyAction {
                    property: "visible"
                  }
                }
              }
            ]

            RowLayout {
              anchors.fill: parent
              anchors.margins: 10

              Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                  anchors.fill: parent
                  spacing: 0

                  Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                      anchors.fill: parent
                      color: Dat.Colors.primary
                      elide: Text.ElideRight
                      font.family: Dat.Fonts.rye
                      font.pointSize: 16
                      text: mprisItem.modelData.trackTitle
                    }
                  }

                  Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                      anchors.fill: parent
                      color: Dat.Colors.tertiary
                      elide: Text.ElideRight
                      font.family: Dat.Fonts.hurricane
                      font.pointSize: 16
                      text: mprisItem.modelData.trackArtist
                    }
                  }
                }
              }

              Rectangle {
                Layout.fillHeight: true
                color: Dat.Colors.primary
                implicitWidth: this.height
                radius: 10

                Gen.MouseArea {
                  layerColor: playPauseIcon.color

                  onClicked: mprisItem.modelData.togglePlaying()
                }

                Gen.MatIcon {
                  id: playPauseIcon

                  anchors.centerIn: parent
                  color: Dat.Colors.on_primary
                  fill: 1
                  font.pointSize: 20
                  icon: (mprisItem.modelData.isPlaying) ? "pause" : "play_arrow"
                }
              }
            }
          }

          Gen.RoundedImage {
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: 20
            source: mprisItem.modelData.trackArtUrl

            Rectangle {
              id: seekButtons

              anchors.margins: 10
              anchors.top: parent.top
              anchors.right: parent.right
              color: Dat.Colors.withAlpha(Dat.Colors.surface_container, 0.9)
              radius: 10
              state: controls.state
              height: 28

              states: [
                State {
                  name: "HIDDEN"

                  PropertyChanges {
                    nextIcon.opacity: 0
                    prevIcon.opacity: 0
                    seekButtons.visible: false
                    seekButtons.width: 0
                  }
                },
                State {
                  name: "REVEALED"

                  PropertyChanges {
                    nextIcon.opacity: 1
                    prevIcon.opacity: 1
                    seekButtons.visible: true
                    seekButtons.width: 55
                  }
                }
              ]
              transitions: [
                Transition {
                  from: "HIDDEN"
                  to: "REVEALED"

                  SequentialAnimation {
                    PropertyAction {
                      property: "visible"
                      target: seekButtons
                    }

                    ParallelAnimation {
                      NumberAnimation {
                        duration: Dat.MaterialEasing.emphasizedTime
                        easing.bezierCurve: Dat.MaterialEasing.emphasized
                        property: "width"
                        target: seekButtons
                      }

                      NumberAnimation {
                        duration: Dat.MaterialEasing.emphasizedTime * 2
                        easing.bezierCurve: Dat.MaterialEasing.emphasized
                        property: "opacity"
                        targets: [prevIcon, nextIcon]
                      }
                    }
                  }
                },
                Transition {
                  from: "REVEALED"
                  to: "HIDDEN"

                  SequentialAnimation {
                    ParallelAnimation {
                      NumberAnimation {
                        duration: Dat.MaterialEasing.standardAccelTime
                        easing.bezierCurve: Dat.MaterialEasing.standardAccel
                        property: "width"
                        target: seekButtons
                      }

                    }

                    PropertyAction {
                      property: "visible"
                      target: seekButtons
                    }
                  }
                }
              ]

              RowLayout {
                anchors.fill: parent

                Item {
                  Layout.fillHeight: true
                  Layout.fillWidth: true

                  MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: mprisItem.modelData.previous()
                    onEntered: prevIcon.fill = 1
                    onExited: prevIcon.fill = 0
                  }

                  Gen.MatIcon {
                    id: prevIcon

                    anchors.centerIn: parent
                    color: Dat.Colors.on_surface
                    font.pointSize: 16
                    icon: "skip_previous"
                  }
                }

                Item {
                  Layout.fillHeight: true
                  Layout.fillWidth: true

                  MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: mprisItem.modelData.next()
                    onEntered: nextIcon.fill = 1
                    onExited: nextIcon.fill = 0
                  }

                  Gen.MatIcon {
                    id: nextIcon

                    anchors.centerIn: parent
                    color: Dat.Colors.on_surface
                    font.pointSize: 16
                    icon: "skip_next"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
