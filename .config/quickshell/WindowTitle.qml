import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

ThemedText {
    Layout.leftMargin: Config.leftSideSpacing
    text: Hyprland.focusedMonitor?.activeWorkspace.toplevels.values.find(t => t.activated)?.title ?? ""
}
