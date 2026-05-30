pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var packages: []

    readonly property string text: `${packages.length} `
    readonly property string textSecondary: {
        const p = packages.join('\n');
        if (p == "") {
            return "No pending updates";
        }
        return p;
    }

    function update() {
        packProc.running = true;
    }

    readonly property int checkInterval: 7200000

    Timer {
        interval: root.checkInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.update();
        }
    }

    Process {
        id: packProc
        command: ["sh", "-c", "checkupdates 2>/dev/null; /usr/bin/paru -Qua 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.packages = text.trim().split(/\n/).filter(x => x !== "");
            }
        }
    }
}
