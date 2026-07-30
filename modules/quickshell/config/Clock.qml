pragma ComponentBehavior: Bound
import QtQuick

ThemedText {
    id: root
    required property var rootWindow

    text: ClockManager.text

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                ClockManager.updateSecondary();
            }
            tooltipLoader.active = hovered;
        }
    }

    Loader {
        id: tooltipLoader
        active: false
        sourceComponent: TextTooltip {
            rootWindow: root.rootWindow
            anchorItem: root
            text: ClockManager.textSecondary
        }
    }
}
