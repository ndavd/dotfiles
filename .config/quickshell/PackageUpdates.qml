import QtQuick
import Quickshell.Io

ThemedText {
    id: packageUpdates

    required property var rootWindow

    property var packages: []

    text: `${packages.length} `

    function update() {
        packProc.running = true;
    }

    Timer {
        interval: 7200000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            packageUpdates.update();
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                packageUpdates.update();
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            }
        }
    }

    Process {
        id: packProc
        command: ["sh", "-c", "checkupdates 2>/dev/null; /usr/bin/paru -Qua 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                packageUpdates.packages = this.text.trim().split(/\n/).filter(x => x !== "");
            }
        }
    }

    TextTooltip {
        id: tooltip
        rootWindow: packageUpdates.rootWindow
        anchorItem: packageUpdates
        text: {
            const p = packageUpdates.packages.join('\n');
            if (p == "") {
                return "No pending updates";
            }
            return p;
        }
    }
}
