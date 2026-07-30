pragma ComponentBehavior: Bound
import QtQuick

ThemedText {
    id: root

    required property var rootWindow

    text: BatteryManager.text
    color: BatteryManager.color

    HoverHandler {
        onHoveredChanged: tooltipLoader.active = hovered
    }

    Loader {
        id: tooltipLoader
        active: false
        sourceComponent: TextTooltip {
            rootWindow: root.rootWindow
            anchorItem: root
            text: BatteryManager.textSecondary
        }
    }
}
