pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real memUsage: 0
    property real memTotal: 0
    property int memUsagePercentage: 0

    readonly property string text: memUsage + "GiB "
    readonly property string textSecondary: `Used ${memUsage} / ${memTotal} (${memUsagePercentage}%)`

    function update() {
        memFile.reload();
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            let total = 0;
            let available = 0;
            for (const line of memFile.text().split("\n")) {
                if (line.startsWith("MemTotal:")) {
                    total = parseInt(line.split(/\s+/)[1]) || 0;
                } else if (line.startsWith("MemAvailable:")) {
                    available = parseInt(line.split(/\s+/)[1]) || 0;
                }
                if (total > 0 && available > 0) {
                    break;
                }
            }
            const used = total - available;
            root.memTotal = (total / Config.kibPerGib).toFixed(2);
            root.memUsage = (used / Config.kibPerGib).toFixed(2);
            root.memUsagePercentage = total > 0 ? Math.round(100 * used / total) : 0;
        }
    }
}
