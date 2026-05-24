import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property var modelData
    screen: modelData

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "black"
    Image {
        anchors.fill: parent
        source: Quickshell.env("HOME") + "/data/pictures/backgrounds/bifurcation.png"
        asynchronous: true
    }
}
