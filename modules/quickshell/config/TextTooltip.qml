import QtQuick
import Quickshell

PopupWindow {
    id: tooltip

    required property var rootWindow
    required property var anchorItem
    property var text

    readonly property int padding: 20

    color: "transparent"
    anchor.window: rootWindow
    anchor.rect.x: anchorItem.parent.x + anchorItem.x + anchorItem.width / 2 - tooltip.implicitWidth / 2
    anchor.rect.y: rootWindow.implicitHeight
    implicitWidth: label.implicitWidth + padding
    implicitHeight: label.implicitHeight + padding
    visible: true

    Rectangle {
        anchors.fill: parent
        color: Config.bg
        radius: 10
        opacity: 0.9
        border.color: Config.fgDim
        border.width: 1

        ThemedText {
            id: label
            anchors.centerIn: parent
            text: tooltip.text ?? ""
        }
    }
}
