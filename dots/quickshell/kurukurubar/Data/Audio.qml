pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property var muted: sink?.audio.muted
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property string sinkIcon: {
    (muted) ? "󰝟" : (volume > 0.5) ? "󰕾" : (volume > 0.01) ? "󰖀" : "󰕿";
  }
  readonly property var sinkMuted: sink?.audio.muted
  readonly property var sinkVolume: sink?.audio.volume
  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property string sourceIcon: (this.sourceMuted) ? "󰍭" : "󰍬"
  readonly property var sourceMuted: source?.audio.muted
  readonly property var sourceVolume: source?.audio.volume
  readonly property var volume: sink?.audio.volume

  function toggleMute(node: PwNode) {
    node.audio.muted = !node.audio.muted;
  }

  function wheelAction(event: WheelEvent, node: PwNode) {
    if (event.angleDelta.y < 0) {
      node.audio.volume -= 0.01;
    } else {
      node.audio.volume += 0.01;
    }

    if (node.audio.volume > 1.3) {
      node.audio.volume = 1.3;
    }
    if (root.sink.audio.volume < 0) {
      node.audio.volume = 0.0;
    }
  }

  PwObjectTracker {
    objects: [root.sink, root.source]
  }
}
