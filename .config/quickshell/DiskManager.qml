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
        command: ["df", "/"]
        stdout: SplitParser {
            onRead: data => {
                if (!data || !data.startsWith("/")) {
                    return;
                }
                const parts = data.trim().split(/\s+/);
                const total = parseInt(parts[1]) || 1;
                const used = parseInt(parts[2]) || 0;
                root.diskTotal = (total / Config.kibPerGib).toFixed(2);
                root.diskUsage = (used / Config.kibPerGib).toFixed(2);
                root.diskUsagePercentage = Math.round(100 * used / total);
            }
        }
    }
}
