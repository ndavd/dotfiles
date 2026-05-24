import QtQuick
import Quickshell

PopupWindow {
    id: tooltip

    required property var rootWindow
    required property var anchorItem
    property var text

    color: "transparent"
    anchor.window: rootWindow ?? null
    anchor.rect.x: anchorItem.parent.x + anchorItem.x + anchorItem.width / 2 - tooltip.implicitWidth / 2
    anchor.rect.y: rootWindow ? rootWindow.implicitHeight : 0
    implicitWidth: label ? label.implicitWidth + 20 : 0
    implicitHeight: label ? label.implicitHeight + 20 : 0
    visible: false

    Rectangle {
        anchors.fill: parent
        color: Config.bg
        radius: 10
        opacity: 0.9
        border.color: Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.15)
        border.width: 1

        ThemedText {
            id: label
            anchors.centerIn: parent
            text: tooltip.text ?? ""
        }
    }
}
