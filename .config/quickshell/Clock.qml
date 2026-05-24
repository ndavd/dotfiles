import QtQuick
import Quickshell.Io

ThemedText {
    id: clock

    required property var rootWindow

    Timer {
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            clock.text = Qt.formatDateTime(new Date(), "dddd, MMM dd HH:mm");
            const now = new Date();
            interval = 60000 - (now.getSeconds() * 1000 + now.getMilliseconds());
        }
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                calProc.running = true;
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            }
        }
    }

    Process {
        id: calProc
        command: ["cal"]
        stdout: StdioCollector {
            onStreamFinished: {
                tooltip.text = this.text.trim();
            }
        }
    }

    TextTooltip {
        id: tooltip
        rootWindow: clock.rootWindow
        anchorItem: clock
    }
}
