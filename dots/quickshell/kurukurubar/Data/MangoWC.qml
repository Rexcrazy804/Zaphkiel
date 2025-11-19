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
    command: ["mmsg", "-w", "-t"]
    running: true

    stdout: SplitParser {
      onRead: line => {
        // Monitor Tag_Number Tag_State Clients Focused_Client
        const regEx = /(.*) tag (\d) (\d) (\d) (\d)/;
        const data = regEx.exec(line);
        if (!data)
          return;
        const display = data[1];
        const tNum = data[2];
        const tState = data[3];
        const tClients = data[4];
        if (tState == "1") {
          root.currentWorkspace = tNum;
        }
      }
    }
  }
}
