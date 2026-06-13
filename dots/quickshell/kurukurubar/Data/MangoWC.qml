pragma Singleton
import Quickshell
import Quickshell.Io

// TODO
// store and expose other values
// like urgency and what not
// multimonitor support?
Singleton {
  id: root

  property string currentWorkspace: "0"

  Process {
    command: ["mmsg", "watch", "focusing-client"]
    running: true

    stdout: SplitParser {
      onRead: line => {
        let data = JSON.parse(line);
        root.currentWorkspace = data.tags[0];
      }
    }
  }

  function setCurrentTag(tagname) {
    Quickshell.execDetached(["mmsg", "dispatch", `view,${tagname}`]);
  }
}
