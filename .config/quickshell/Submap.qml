import QtQuick
import Quickshell.Hyprland

ThemedText {
    id: submap

    color: "#1ca000"
    opacity: 0.8

    visible: submap.text !== ""

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "submap") {
                submap.text = event.data == "" ? "" : `s^${event.data}`;
            }
        }
    }
}
