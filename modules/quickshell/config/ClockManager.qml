pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string text: ""
    property string textSecondary: ""

    function updateSecondary() {
        calProc.running = true;
    }

    Timer {
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.text = Qt.formatDateTime(new Date(), "dddd, MMM dd HH:mm");
            const now = new Date();
            interval = 60000 - (now.getSeconds() * 1000 + now.getMilliseconds());
        }
    }

    Process {
        id: calProc
        command: ["cal"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.textSecondary = text.trim();
            }
        }
    }
}
