import QtQuick
import Quickshell.Io

ThemedText {
    id: cpu

    required property var rootWindow

    property int cpuUsage: 0
    property var cpuCoreUsages: []

    property int lastCpuTotal: 0
    property int lastCpuIdle: 0
    property var lastCpuCoreTotals: []
    property var lastCpuCoreIdles: []

    text: cpuUsage + "% "

    function update() {
        cpuProc.running = true;
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                cpu.update();
                tooltip.visible = true;
            } else {
                tooltip.visible = false;
            }
        }
    }

    // running another time soon after startup so that it can populate the first values
    Timer {
        interval: 500
        repeat: false
        running: true
        onTriggered: cpu.update()
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "cat /proc/stat | grep cpu"]

        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    return;
                }
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

                var usagePercentage = (total - idle) / total * 100;

                const coreIndex = name != "cpu" ? parseInt(name.replace("cpu", "")) : null;

                const lastTotal = coreIndex == null ? cpu.lastCpuTotal : cpu.lastCpuCoreTotals[coreIndex];
                if (lastTotal > 0) {
                    const lastIdle = coreIndex == null ? cpu.lastCpuIdle : cpu.lastCpuCoreIdles[coreIndex];
                    const totalDiff = total - lastTotal;
                    const idleDiff = idle - lastIdle;
                    const cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);
                    if (coreIndex == null) {
                        cpu.cpuUsage = cpuUsage;
                    } else {
                        const usages = cpu.cpuCoreUsages.slice();
                        usages[coreIndex] = cpuUsage;
                        cpu.cpuCoreUsages = usages;
                    }
                }

                if (coreIndex == null) {
                    cpu.lastCpuTotal = total;
                    cpu.lastCpuIdle = idle;
                } else {
                    const lastTotals = cpu.lastCpuCoreTotals.slice();
                    const lastIdles = cpu.lastCpuCoreIdles.slice();
                    lastTotals[coreIndex] = total;
                    lastIdles[coreIndex] = idle;
                    cpu.lastCpuCoreTotals = lastTotals;
                    cpu.lastCpuCoreIdles = lastIdles;
                }
            }
        }
    }

    TextTooltip {
        id: tooltip
        rootWindow: cpu.rootWindow
        anchorItem: cpu
        text: cpu.cpuCoreUsages.map((usage, i) => `Core ${i}: ${usage}%`).join("\n")
    }
}
