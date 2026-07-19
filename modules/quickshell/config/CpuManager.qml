pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: 0

    property var cpuCoreUsages: []

    property int lastCpuTotal: 0
    property int lastCpuIdle: 0
    property var lastCpuCoreTotals: []
    property var lastCpuCoreIdles: []

    readonly property string text: cpuUsage + "% "
    readonly property string textSecondary: cpuCoreUsages.map((usage, i) => `Core ${i}: ${usage}%`).join("\n")

    function update() {
        cpuFile.reload();
    }

    // running another time soon after startup so that it can populate the first values
    Timer {
        interval: 500
        repeat: false
        running: true
        onTriggered: root.update()
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onLoaded: {
            const newCoreTotals = [];
            const newCoreIdles = [];
            const newCoreUsages = root.cpuCoreUsages.slice();
            let newCpuTotal = root.lastCpuTotal;
            let newCpuIdle = root.lastCpuIdle;
            let newCpuUsage = root.cpuUsage;

            for (const data of cpuFile.text().split("\n").filter(x => x.startsWith("cpu"))) {
                const parts = data.trim().split(/\s+/);
                const name = parts[0];
                const user = parseInt(parts[1]) || 0;
                const nice = parseInt(parts[2]) || 0;
                const system = parseInt(parts[3]) || 0;
                const _idle = parseInt(parts[4]) || 0;
                const iowait = parseInt(parts[5]) || 0;
                const irq = parseInt(parts[6]) || 0;
                const softirq = parseInt(parts[7]) || 0;
                const total = user + nice + system + _idle + iowait + irq + softirq;
                const idle = _idle + iowait;
                const coreIndex = name !== "cpu" ? parseInt(name.replace("cpu", "")) : null;

                if (coreIndex === null) {
                    if (root.lastCpuTotal > 0) {
                        const totalDiff = total - root.lastCpuTotal;
                        const idleDiff = idle - root.lastCpuIdle;
                        if (totalDiff > 0) {
                            newCpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
                        }
                    }
                    newCpuTotal = total;
                    newCpuIdle = idle;
                } else {
                    const lastTotal = root.lastCpuCoreTotals[coreIndex] ?? 0;
                    if (lastTotal > 0) {
                        const totalDiff = total - lastTotal;
                        const idleDiff = idle - (root.lastCpuCoreIdles[coreIndex] ?? 0);
                        if (totalDiff > 0) {
                            newCoreUsages[coreIndex] = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
                        }
                    }
                    newCoreTotals[coreIndex] = total;
                    newCoreIdles[coreIndex] = idle;
                }
            }

            root.lastCpuTotal = newCpuTotal;
            root.lastCpuIdle = newCpuIdle;
            root.cpuUsage = newCpuUsage;
            root.lastCpuCoreTotals = newCoreTotals;
            root.lastCpuCoreIdles = newCoreIdles;
            root.cpuCoreUsages = newCoreUsages;
        }
    }
}
