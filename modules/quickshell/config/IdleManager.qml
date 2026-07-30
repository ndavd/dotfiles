pragma Singleton

import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Singleton {
    readonly property bool isIdle: lockMonitor.isIdle

    IdleMonitor {
        id: lockMonitor
        timeout: 300
        onIsIdleChanged: {
            if (isIdle) {
                LockManager.lock();
            }
        }
    }

    IdleMonitor {
        timeout: 330
        onIsIdleChanged: {
            if (isIdle) {
                dpmsOff.running = true;
            } else {
                dpmsOn.running = true;
            }
        }
    }

    Process {
        id: dpmsOff
        command: ["hyprctl", "dispatch", `hl.dsp.dpms({ action = "off" })`]
    }

    Process {
        id: dpmsOn
        command: ["hyprctl", "dispatch", `hl.dsp.dpms({ action = "on" })`]
    }
}
