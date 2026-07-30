pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property string text: ""
    readonly property bool visible: text != ""

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "submap") {
                root.text = event.data == "" ? "" : `s^${event.data}`;
            }
        }
    }
}
