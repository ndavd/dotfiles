pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

RowLayout {
    id: root
    required property var rootWindow

    visible: PrivacyManager.visible

    Repeater {
        model: PrivacyManager.icons
        WrapperMouseArea {
            id: privacyIcon
            required property var modelData

            Layout.alignment: Qt.AlignVCenter

            child: ThemedText {
                opacity: 0.7
                font.pixelSize: Config.fontSize
                color: privacyIcon.modelData.color
                text: privacyIcon.modelData.icon
            }

            HoverHandler {
                onHoveredChanged: tooltipLoader.active = hovered
            }

            Loader {
                id: tooltipLoader
                active: false
                sourceComponent: TextTooltip {
                    rootWindow: root.rootWindow
                    anchorItem: root
                    text: privacyIcon.modelData.apps.join("\n")
                }
            }
        }
    }
}
