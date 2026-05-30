pragma ComponentBehavior: Bound
import QtQuick

ThemedText {
    id: root
    required property var rootWindow

    text: PackageUpdatesManager.text

    HoverHandler {
        onHoveredChanged: {
            if (hovered) {
                PackageUpdatesManager.update();
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
            text: PackageUpdatesManager.textSecondary
        }
    }
}
