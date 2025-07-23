pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick
import qs.Data as Dat
import qs.Widgets as Wid
import qs.Generics as Gen

ShellRoot {
  id: root

  readonly property string sessions: Quickshell.env("KURU_DM_SESSIONS")
  readonly property string wallpaper_path: Quickshell.env("KURU_DM_WALLPATH")

  Component.onCompleted: {
    if (sessions == "") {
      console.log("[WARN] empty sessions list, defaulting to hyprland");
      sessions.current_session = "hyprland";
      sessions.current_session_name = "hyprland";
    }
  }

  WlSessionLock {
    id: sessionLock

    property string user_passwd

    locked: true

    WlSessionLockSurface {
      Wid.Wallpaper {
        anchors.fill: parent
        source: root.wallpaper_path
      }

      Rectangle {
        anchors.fill: parent

        gradient: Gradient {
          GradientStop {
            color: "transparent"
            position: 0.0
          }

          GradientStop {
            color: Dat.Colors.background
            position: 1.0
          }
        }

        Item {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          height: userText.contentWidth
          width: userText.contentHeight

          Text {
            id: userText

            anchors.centerIn: parent
            color: Dat.Colors.on_background
            font.bold: true
            font.family: "Libre Barcode 128 TEXT"
            font.pointSize: 84
            layer.enabled: true
            layer.smooth: true
            renderType: Text.NativeRendering
            rotation: -90
            text: users.current_user
          }

          MouseArea {
            anchors.fill: parent

            onClicked: users.next()
          }
        }

        Item {
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          height: sessionText.contentWidth
          width: sessionText.contentHeight

          Text {
            id: sessionText

            anchors.centerIn: parent
            color: Dat.Colors.on_background
            font.bold: true
            font.family: "Libre Barcode 128 TEXT"
            font.pointSize: 84
            layer.enabled: true
            layer.smooth: true
            renderType: Text.NativeRendering
            rotation: 90
            text: sessions.current_session_name
          }

          MouseArea {
            anchors.fill: parent

            onClicked: sessions.next()
          }
        }

        // Text {
        //   color: Dat.Colors.on_background
        //   font.family: "CaskaydiaMono NF"
        //   font.pointSize: 32
        //   renderType: Text.NativeRendering
        //   text: Qt.formatDateTime(Dat.Clock.date, "HH MM")
        //
        //   anchors {
        //     bottom: parent.bottom
        //     bottomMargin: 10
        //     horizontalCenter: parent.horizontalCenter
        //   }
        // }
      }

      Rectangle {
        anchors.centerIn: parent
        color: Dat.Colors.surface
        height: this.width
        radius: this.width
        width: 50

        Gen.MouseArea {
          anchors.fill: parent

          onClicked: {
            Greetd.createSession(users.current_user);
          }
        }

        Gen.MatIcon {
          anchors.centerIn: parent
          color: Dat.Colors.on_surface
          font.pointSize: 18
          icon: "lock"
        }
      }
    }
  }

  Connections {
    function onAuthMessage(message, error, responseRequired, echoResponse) {
      console.log("[MSG] " + message);
      console.log("[ERR] " + error);
      if (responseRequired) {
        Greetd.respond("kokomi");
      }
    }

    function onReadyToLaunch() {
      sessionLock.locked = false;
      console.log("[GREETD EXEC]" + sessions.current_session)
      Greetd.launch(sessions.current_session.split(" "));
    }

    target: Greetd
  }

  Process {
    id: users

    property string current_user: users_list[current_user_index]
    property int current_user_index: 0
    property list<string> users_list: []

    function next() {
      current_user_index = (current_user_index + 1) % users_list.length;
    }

    command: ["awk", `BEGIN { FS = ":"} /\\/home/ { print $1 }`, "/etc/passwd"]
    running: true

    stderr: SplitParser {
      onRead: data => console.log("[ERR] " + data)
    }
    stdout: SplitParser {
      onRead: data => {
        console.log("[USER] " + data);
        users.users_list.push(data);
      }
    }
  }

  Process {
    id: sessions

    property int current_ses_index: 0
    property string current_session: session_execs[current_ses_index]
    property string current_session_name: session_names[current_ses_index]
    property list<string> session_execs: []
    property list<string> session_names: []

    function next() {
      current_ses_index = (current_ses_index + 1) % session_execs.length;
    }

    command: [Qt.resolvedUrl("./scripts/session.sh"), root.sessions]
    running: true

    stderr: SplitParser {
      onRead: data => console.log("[ERR] " + data)
    }
    stdout: SplitParser {
      onRead: data => {
        console.log("[SESSION] " + data);
        const parsedData = data.split(",");
        sessions.session_names.push(parsedData[0]);
        sessions.session_execs.push(parsedData[1]);
      }
    }
  }
}
