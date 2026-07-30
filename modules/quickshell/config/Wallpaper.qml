import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
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
        source: Qt.resolvedUrl("./bifurcation.png")
        asynchronous: true
    }
}
