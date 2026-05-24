import QtQuick
import Quickshell.Io

ThemedText {
    id: disk

    required property var rootWindow

    property real diskUsage: 0
    property real diskTotal: 0
    property int diskUsagePercentage: 0

    text: (diskTotal - diskUsage).toFixed(2) + "GiB "

    function update() {
        diskProc.running = true;
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                disk.update();
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            }
        }
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df / | tail -n1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    return;
                }
                const parts = data.trim().split(/\s+/);
                const total = parseInt(parts[1]) || 1;
                const used = parseInt(parts[2]) || 0;
                disk.diskTotal = (total / 1048576).toFixed(2);
                disk.diskUsage = (used / 1048576).toFixed(2);
                disk.diskUsagePercentage = 100 * used / total;
            }
        }
    }

    TextTooltip {
        id: tooltip
        rootWindow: disk.rootWindow
        anchorItem: disk
        text: `Used ${disk.diskUsage} / ${disk.diskTotal} (${disk.diskUsagePercentage}%)`
    }
}
