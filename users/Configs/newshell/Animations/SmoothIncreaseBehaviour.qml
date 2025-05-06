import QtQuick
Behavior {
  id: root
  property QtObject animTarget: targetProperty.object
  required property int duration
  required property var easing
  NumberAnimation {
    target: root.animTarget
    property: root.targetProperty.name
    duration: root.duration
    easing.type: root.easing
  }
}
