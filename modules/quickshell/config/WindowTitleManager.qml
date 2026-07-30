pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    readonly property string text: Hyprland.focusedMonitor?.activeWorkspace.toplevels?.values.find(t => t.activated)?.title ?? ""
}
