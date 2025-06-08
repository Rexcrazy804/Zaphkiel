import QtQuick
import QtQuick.Layouts

import "../Data/" as Dat
import "../Generics/" as Gen

Item {
  id: root

  property int kills: 0
  property string name: "game"
  property bool killed: deathTimer.running
  property bool fired: false

  clip: true

  Image {
    anchors.fill: parent
    source: "../Assets/aurahorn.png"
    fillMode: Image.PreserveAspectFit
    verticalAlignment: Image.AlignTop
  }

  Component {
    id: arrowSprite

    AnimatedSprite {
      id: sprite

      required property Timer deathTimer
      required property SpriteSequence gobSeq

      anchors.bottomMargin: -13
      frameHeight: 64
      frameWidth: 64
      source: "../Assets/elf/ElfArrow001-Sheet-export.png"
      visible: true

      ParallelAnimation {
        running: true

        PropertyAction {
          property: "visible"
        }

        SequentialAnimation {
          NumberAnimation {
            duration: 500
            easing.type: Easing.Linear
            property: "x"
            target: sprite
            to: 700
          }

          ScriptAction {
            script: {
              if (sprite.gobSeq.currentSprite != "death") {
                sprite.gobSeq.jumpTo("death");
                sprite.deathTimer.start();
              }
              sprite.destroy();
            }
          }
        }
      }
    }
  }

  SpriteSequence {
    // figure this out
    // running: Dat.Globals.stack.currentItem.name === root.name
    id: elfSeq

    anchors.bottom: floor.top
    anchors.bottomMargin: -48
    anchors.left: parent.left
    anchors.leftMargin: -48
    goalSprite: "walking"
    height: 144
    width: 160

    sprites: [
      Sprite {
        frameCount: 8
        frameHeight: 144
        frameRate: 10
        frameWidth: 160
        name: "walking"
        source: "../Assets/elf/ElfWalk001-Sheet-export.png"
      },
      Sprite {
        frameCount: 7
        frameHeight: 144
        frameRate: 10
        frameWidth: 160
        name: "shooting"
        source: "../Assets/elf/ElfBasicAtk001BGR-Sheet-export.png"
        to: {
          "walking": 1,
          "shooting": 0
        }
      }
    ]
  }

  // kinda hacky but hey it works
  Timer {
    id: shootTimer

    interval: 200

    onTriggered: {
      root.fired = true
      let mySprite = arrowSprite.incubateObject(root, {
        "anchors.bottom": floor.top,
        "gobSeq": gobSeq,
        "deathTimer": deathTimer
      });
    }
  }

  // starts animation after goblin dies
  Timer {
    id: deathTimer

    interval: 500

    onTriggered: {
      refreshGoblin.start();
      root.kills += 1;
      root.fired = false
    }
  }

  // animation for gobSeq
  SequentialAnimation {
    id: refreshGoblin

    NumberAnimation {
      duration: 400
      property: "x"
      target: gobSeq
      to: 750
    }

    NumberAnimation {
      duration: 1200
      property: "x"
      target: gobSeq
      to: 670
    }
  }

  SpriteSequence {
    id: gobSeq

    anchors.bottom: floor.top
    anchors.bottomMargin: -18
    height: 100
    running: true
    width: 100
    x: 670

    sprites: [
      Sprite {
        frameCount: 6
        frameHeight: 100
        frameRate: 10
        frameWidth: 100
        name: "walking"
        source: "../Assets/elf/goblinrun.png"
      },
      Sprite {
        frameCount: 8
        frameHeight: 100
        frameRate: 10
        frameWidth: 100
        name: "death"
        source: "../Assets/elf/goblindeath.png"
        to: {
          "walking": 1
        }
      }
    ]
    transform: Scale {
      origin.x: gobSeq.width / 2
      xScale: -1
    }
  }

  Rectangle {
    id: floor

    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    bottomLeftRadius: 20
    bottomRightRadius: 20
    color: Dat.Colors.surface_container_high
    height: 50

    Text {
      anchors.centerIn: parent
      color: Dat.Colors.primary
      font.family: Dat.Fonts.rye
      font.pointSize: 24
      text: "Goblin Slayer"
    }

    RowLayout {
      anchors.fill: parent
      anchors.margins: 5

      Rectangle {
        Layout.fillHeight: true
        color: Dat.Colors.primary
        implicitWidth: this.height ? this.height : 1
        radius: 10

        Gen.MouseArea {
          id: attackArea

          anchors.fill: parent
          layerColor: attackIcon.color

          onClicked: {
            if (elfSeq.currentSprite == "shooting") {
              return;
            }
            elfSeq.jumpTo("shooting");
            shootTimer.start();
            // arrowSprite.createObject(root, {
            //   "anchors.bottom": floor.top
            // });
          }
        }

        Gen.MatIcon {
          id: attackIcon

          anchors.centerIn: parent
          color: Dat.Colors.on_primary
          fill: attackArea.containsMouse
          font.pointSize: 16
          icon: "sword_rose"
        }
      }

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
      }

      Rectangle {
        Layout.rightMargin: 5
        clip: true
        color: Dat.Colors.primary
        implicitHeight: 32
        implicitWidth: hpRow.width + 20
        radius: 10

        Behavior on implicitWidth {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime
            easing.bezierCurve: Dat.MaterialEasing.emphasized
          }
        }

        RowLayout {
          id: hpRow

          anchors.centerIn: parent
          height: parent.height

          Gen.MatIcon {
            color: Dat.Colors.on_primary
            fill: deathTimer.running
            icon: "skull"
          }

          Text {
            color: Dat.Colors.on_primary
            text: root.kills + "x"
          }
        }
      }
    }
  }
}
