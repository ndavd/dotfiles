pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Repeater {
    required property var screen

    model: Hyprland.workspaces.values.filter(w => w.monitor && w.monitor.name == screen.name)

    Rectangle {
        id: workspace
        required property var modelData
        property bool isFocused: Hyprland.focusedWorkspace?.id == modelData.id

        Layout.fillHeight: true
        width: Config.h
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
