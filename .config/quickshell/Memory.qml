import QtQuick
import Quickshell.Io

ThemedText {
    id: memory

    required property var rootWindow

    property real memUsage: 0
    property real memTotal: 0
    property int memUsagePercentage: 0

    text: memUsage + "GiB "

    function update() {
        memProc.running = true;
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                memory.update();
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            }
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    return;
                }
                const parts = data.trim().split(/\s+/);
                const total = parseInt(parts[1]) || 1;
                const used = parseInt(parts[2]) || 0;
                memory.memTotal = (total / 1048576).toFixed(2);
                memory.memUsage = (used / 1048576).toFixed(2);
                memory.memUsagePercentage = 100 * used / total;
            }
        }
    }

    TextTooltip {
        id: tooltip
        rootWindow: memory.rootWindow
        anchorItem: memory
        text: `Used ${memory.memUsage} / ${memory.memTotal} (${memory.memUsagePercentage}%)`
    }
}
