pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real diskUsage: 0
    property real diskTotal: 0
    property int diskUsagePercentage: 0

    readonly property string text: (diskTotal - diskUsage).toFixed(2) + "GiB "
    readonly property string textSecondary: `Used ${diskUsage} / ${diskTotal} (${diskUsagePercentage}%)`

    function update() {
        diskProc.running = true;
    }

    Process {
        id: diskProc
        command: ["btrfs", "filesystem", "usage", "-g", "/"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    return;
                }
                const line = data.trim();

                if (line.startsWith("Device size")) {
                    const lineParts = line.split(/\s+/);
                    root.diskTotal = parseFloat(lineParts[lineParts.length - 1].slice(0, -3)).toFixed(2);
                } else if (line.startsWith("Used")) {
                    const lineParts = line.split(/\s+/);
                    root.diskUsage = parseFloat(lineParts[lineParts.length - 1].slice(0, -3)).toFixed(2);
                }

                if (root.diskTotal && root.diskUsage) {
                    root.diskUsagePercentage = Math.round(100 * root.diskUsage / root.diskTotal);
                }
            }
        }
    }
}
