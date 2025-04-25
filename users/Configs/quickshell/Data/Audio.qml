pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property var volume: sink?.audio.volume
  readonly property var muted: sink?.audio.muted

  readonly property var micMuted: source?.audio.muted
  readonly property var micVolume: source?.audio.volume
  readonly property string micIcon: (this.micMuted)? "󰍭" : "󰍬"
  readonly property string volIcon: { 
    (muted)? "󰝟" :
    (volume > 0.5)? "󰕾" :
    (volume > 0.01)? "󰖀" : "󰕿"
  }
  PwObjectTracker { objects: [ root.sink, root.source ] }

  function wheelAction(event: WheelEvent) {
    if (event.angleDelta.y < 0) {
      root.sink.audio.volume = root.volume - 0.01
    } else {
      root.sink.audio.volume = root.volume + 0.01
    }

    if (root.sink.audio.volume > 1.3) {
      root.sink.audio.volume = 1.3
    }
    if (root.sink.audio.volume < 0) {
      root.sink.audio.volume = 0.0
    }
  }

  function micWheelAction(event: WheelEvent) {
    if (event.angleDelta.y < 0) {
      root.source.audio.volume = root.micVolume - 0.01
    } else {
      root.source.audio.volume = root.micVolume + 0.01
    }

    if (root.source.audio.volume > 1) {
      root.source.audio.volume = 1
    }
    if (root.source.audio.volume < 0) {
      root.source.audio.volume = 0.0
    }
  }
}
