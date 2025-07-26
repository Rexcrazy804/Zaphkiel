// why is it in a single file?
// I am the lazy, I should modularize this eventually
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

  // instant_auth starts authentication instantly, great for finger print login
  // without having to hit enter (sumee's major grevience)
  readonly property string instant_auth: Quickshell.env("KURU_DM_INSTANTAUTH")
  readonly property string preferred_session: Quickshell.env("KURU_DM_PREF_SES")
  readonly property string preferred_user: Quickshell.env("KURU_DM_PREF_USR")
  readonly property string sessions: Quickshell.env("KURU_DM_SESSIONS") ?? console.log("[ERROR] SESSIONS DIR EMPTY")
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
    readonly property bool unlocking: Greetd.state == GreetdState.Authenticating

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
      }

      Item {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: userText.contentWidth
        width: userText.contentHeight

        Item {
          id: userRect

          height: parent.height
          width: parent.width

          Gen.BarCode {
            id: userText

            anchors.centerIn: parent
            color: Dat.Colors.on_background
            font.pointSize: 69
            rotation: -90
            text: users.current_user
            withText: true

            // TODO make this seq animation a generic
            // A really need a lesson on DRY >.<
            Behavior on text {
              SequentialAnimation {
                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "x"
                  target: userRect
                  to: -userText.contentHeight
                }

                PropertyAction {
                  property: "text"
                  target: userText
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardDecel
                  property: "x"
                  target: userRect
                  to: 0
                }
              }
            }
          }
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

        Item {
          id: sessionRect

          height: parent.height
          width: parent.width

          Gen.BarCode {
            id: sessionText

            anchors.centerIn: parent
            color: Dat.Colors.on_background
            font.pointSize: 69
            rotation: 90
            // fooking 39 varient doesnt support () brackets
            text: sessions.current_session_name.replace(/\(|\)/g, "")
            withText: true

            Behavior on text {
              SequentialAnimation {
                NumberAnimation {
                  duration: Dat.MaterialEasing.standardAccelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardAccel
                  property: "x"
                  target: sessionRect
                  to: sessionText.contentHeight
                }

                PropertyAction {
                  property: "text"
                  target: sessionText
                }

                NumberAnimation {
                  duration: Dat.MaterialEasing.standardDecelTime
                  easing.bezierCurve: Dat.MaterialEasing.standardDecel
                  property: "x"
                  target: sessionRect
                  to: 0
                }
              }
            }
          }
        }

        MouseArea {
          anchors.fill: parent

          onClicked: sessions.next()
        }
      }

      ListView {
        id: fakeInputList

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 100
        orientation: ListView.Horizontal

        add: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardDecelTime
            easing.bezierCurve: Dat.MaterialEasing.standardDecel
            from: -100
            property: "y"
            to: 0
          }
        }
        delegate: Gen.BarCode {
          required property string modelData

          color: Dat.Colors.on_background
          font.pointSize: 48
          text: modelData
        }
        model: ScriptModel {
          values: sessionLock.fakeBuffer.split("")
        }
        remove: Transition {
          NumberAnimation {
            duration: Dat.MaterialEasing.standardAccelTime
            easing.bezierCurve: Dat.MaterialEasing.standardAccel
            property: "y"
            to: -100
          }
        }
      }

      Rectangle {
        anchors.centerIn: parent
        clip: true
        color: Dat.Colors.surface
        height: 40
        radius: this.width
        width: inputRow.width

        Behavior on width {
          NumberAnimation {
            duration: Dat.MaterialEasing.emphasizedTime
            easing.bezierCurve: Dat.MaterialEasing.emphasized
          }
        }

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

        MouseArea {
          id: inputMArea

          anchors.fill: parent
          hoverEnabled: true

          RowLayout {
            id: inputRow

            anchors.centerIn: parent
            height: parent.height

            Item {
              Layout.fillHeight: true
              implicitWidth: this.height
              visible: inputMArea.containsMouse && !sessionLock.unlocking

              Gen.MouseArea {
                anchors.fill: parent
                anchors.margins: 4

                onClicked: Dat.SessionActions.poweroff()
              }

              Gen.MatIcon {
                anchors.centerIn: parent
                antialiasing: true
                color: lockIcon.color
                fill: 1
                font.pointSize: 16
                icon: "mode_off_on"
              }
            }

            Item {
              id: lockContainer

              Layout.fillHeight: true
              implicitWidth: height

              Gen.MouseArea {
                anchors.fill: parent

                onClicked: root.authenticate()
              }

              Gen.MatIcon {
                id: lockIcon

                anchors.centerIn: parent
                color: Dat.Colors.on_surface
                fill: sessionLock.unlocking
                font.pointSize: 18
                icon: "lock"

                Behavior on rotation {
                  NumberAnimation {
                    duration: lockRotatetimer.interval
                    easing.type: Easing.Linear
                  }
                }

                SequentialAnimation {
                  id: lockErrAnimation

                  PropertyAction {
                    property: "color"
                    target: lockIcon
                    value: Dat.Colors.error
                  }

                  PauseAnimation {
                    duration: 240
                  }

                  PropertyAction {
                    property: "color"
                    target: lockIcon
                    value: Dat.Colors.on_error
                  }
                }

                Timer {
                  id: lockRotatetimer

                  interval: 500
                  repeat: true
                  running: sessionLock.unlocking
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

            Item {
              Layout.fillHeight: true
              implicitWidth: this.height
              visible: inputMArea.containsMouse && !sessionLock.unlocking

              Gen.MouseArea {
                anchors.fill: parent
                anchors.margins: 4

                onClicked: Dat.SessionActions.reboot()
              }

              Gen.MatIcon {
                anchors.centerIn: parent
                antialiasing: true
                color: lockIcon.color
                fill: 1
                font.pointSize: 16
                icon: "restart_alt"
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
      console.log("[RESREQ] " + responseRequired);
      console.log("[ECHO] " + echoResponse);

      if (responseRequired) {
        Greetd.respond(sessionLock.passwdBuffer);
        sessionLock.passwdBuffer = "";
        sessionLock.fakeBuffer = "";
        return;
      }

      // finger print segs
      // https://github.com/rharish101/ReGreet/blob/f74b193adbae9502b6aa9eafa810a06c5df90529/src/gui/model.rs#L288
      Greetd.respond("");
    }

    function onReadyToLaunch() {
      sessionLock.locked = false;
      console.log("[GREETD EXEC] " + sessions.current_session);
      Greetd.launch(sessions.current_session.split(" "));
    }

    target: Greetd
  }

  Process {
    id: users

    property string current_user: users_list[current_user_index] ?? ""
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
        if (data == root.preferred_user) {
          console.log("[INFO] Found preferred user " + root.preferred_user);
          users.current_user_index = users.users_list.length;
        }
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
    property string current_session: session_execs[current_ses_index] ?? "hyprland"
    property string current_session_name: session_names[current_ses_index] ?? "Hyrpland"
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
        const parsedData = data.split(",");
        console.log("[SESSIONS] " + parsedData[2]);
        if (parsedData[0] == root.preferred_session) {
          console.log("[INFO] Found preferred session " + root.preferred_session);
          sessions.current_ses_index = sessions.session_names.length;
        }
        sessions.session_names.push(parsedData[1]);
        sessions.session_execs.push(parsedData[2]);
      }
    }

    onExited: if (root.instant_auth && !users.running) {
      console.log("[SESIONS EXIT]");
      root.authenticate();
    }
  }
}
