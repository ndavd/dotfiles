pragma ComponentBehavior: Bound
import QtQuick

ThemedText {
    id: root
    required property var rootWindow

    text: CpuManager.text

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                CpuManager.update();
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
            text: CpuManager.textSecondary
        }
    }
}
