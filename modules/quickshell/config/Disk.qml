pragma ComponentBehavior: Bound
import QtQuick

ThemedText {
    id: root
    required property var rootWindow

    text: DiskManager.text

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                DiskManager.update();
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
            text: DiskManager.textSecondary
        }
    }
}
