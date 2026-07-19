pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Repeater {
    id: root

    required property var screen

    model: ScriptModel {
        values: Hyprland.workspaces.values.filter(w => w.monitor?.name && w.monitor.name == root.screen.name)
    }

    Rectangle {
        id: workspace
        required property var modelData
        readonly property bool isFocused: Hyprland.focusedWorkspace?.id == modelData.id

        Layout.fillHeight: true
        width: Config.statusBarHeight
        color: isFocused ? Config.primary : "transparent"

        ThemedText {
            id: text_item
            anchors.centerIn: parent

            text: workspace.modelData.id

            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Hyprland.dispatch("hl.dsp.focus({workspace = " + workspace.modelData.id + "})")
        }
    }
}
