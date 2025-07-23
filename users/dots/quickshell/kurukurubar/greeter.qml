pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd

import qs.Data as Dat
import qs.Widgets as Wid
import qs.Generics as Gen

ShellRoot {
  id: root

  // starts authentication instantly, great for finger print login without having to
  // hit enter (sumee's major grevience)
  // TODO preferred session and preferred user
  readonly property string instant_auth: Quickshell.env("KURU_DM_INSTANTAUTH")
  readonly property string sessions: Quickshell.env("KURU_DM_SESSIONS")
  readonly property string wallpaper_path: Quickshell.env("KURU_DM_WALLPATH")

  function authenticate() {
    Greetd.createSession(users.current_user);
  }

  Component.onCompleted: {
    if (sessions == "") {
      console.log("[WARN] empty sessions list, defaulting to hyprland");
      sessions.current_session = "hyprland";
      sessions.current_session_name = "hyprland";
    }
  }

  WlSessionLock {
    id: sessionLock

    property string fakeBuffer: ""
    readonly property list<string> kokomi: ["k", "o", "k", "o", "m", "i"]
    property string passwdBuffer: ""

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
            renderType: Text.NativeRendering
            rotation: 90
            text: sessions.current_session_name
          }

          MouseArea {
            anchors.fill: parent

            onClicked: sessions.next()
          }
        }
      }

      Rectangle {
        anchors.centerIn: parent
        color: Dat.Colors.surface
        height: 40
        radius: this.width
        width: inputRow.width

        Item {
          anchors.fill: parent
          focus: true

          Keys.onPressed: kevent => {
            if (Greetd.state != GreetdState.Inactive) {
              return;
            }

            if (kevent.key === Qt.Key_Enter || kevent.key === Qt.Key_Return) {
              root.authenticate();
              return;
            }

            if (kevent.key === Qt.Key_Backspace) {
              if (kevent.modifiers & Qt.ControlModifier) {
                sessionLock.passwdBuffer = "";
                sessionLock.fakeBuffer = "";
                return;
              }

              sessionLock.passwdBuffer = sessionLock.passwdBuffer.slice(0, -1);
              sessionLock.fakeBuffer = sessionLock.fakeBuffer.slice(0, -1);
              return;
            }

            if (kevent.text) {
              sessionLock.passwdBuffer += kevent.text;
              sessionLock.fakeBuffer += sessionLock.kokomi[Math.floor(Math.random() * 6)];
            }
          }
        }

        RowLayout {
          id: inputRow

          anchors.centerIn: parent
          height: parent.height

          Item {
            Layout.fillHeight: true
            Layout.leftMargin: 15
            clip: true
            implicitWidth: fakePasw.contentWidth
            visible: implicitWidth != 0

            Behavior on implicitWidth {
              NumberAnimation {
                duration: Dat.MaterialEasing.emphasizedTime
                easing.bezierCurve: Dat.MaterialEasing.emphasized
              }
            }

            Text {
              id: fakePasw

              anchors.centerIn: parent
              anchors.verticalCenterOffset: contentHeight * 0.2
              color: Dat.Colors.on_background
              font.bold: true
              font.family: "Libre Barcode 128"
              font.pointSize: 22
              renderType: Text.NativeRendering
              text: sessionLock.fakeBuffer
            }
          }

          Item {
            Layout.fillHeight: true
            implicitWidth: height

            Gen.MouseArea {
              anchors.fill: parent

              onClicked: root.authenticate()
            }

            Gen.MatIcon {
              anchors.centerIn: parent
              color: Dat.Colors.on_surface
              fill: Greetd.state == GreetdState.Authenticating
              font.pointSize: 18
              icon: "lock"

              Behavior on rotation {
                NumberAnimation {
                  duration: lockRotatetimer.interval
                  easing.type: Easing.Linear
                }
              }

              Timer {
                id: lockRotatetimer

                interval: 500
                repeat: true
                running: Greetd.state == GreetdState.Authenticating
                triggeredOnStart: true

                onRunningChanged: if (parent.rotation < 180) {
                  parent.rotation = 360;
                } else {
                  parent.rotation = 0;
                }
                onTriggered: parent.rotation += 50
              }
            }
          }
        }
      }
    }
  }

  Connections {
    function onAuthMessage(message, error, responseRequired, echoResponse) {
      console.log("[MSG] " + message);
      console.log("[ERR] " + error);
      if (responseRequired) {
        Greetd.respond(sessionLock.passwdBuffer);
        sessionLock.passwdBuffer = "";
        sessionLock.fakeBuffer = "";
      }
    }

    function onReadyToLaunch() {
      sessionLock.locked = false;
      console.log("[GREETD EXEC]" + sessions.current_session);
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
        console.log("[USERS] " + data);
        users.users_list.push(data);
      }
    }

    // very unlikely that this completes later than sessions better to be safe
    // nonetheless
    onExited: if (root.instant_auth && !users.running) {
      console.log("[USERS EXIT]");
      root.authenticate();
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

    onExited: if (root.instant_auth && !users.running) {
      console.log("[SESIONS EXIT]");
      root.authenticate();
    }
  }
}
