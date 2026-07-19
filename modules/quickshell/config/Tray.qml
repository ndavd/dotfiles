pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
    id: tray
    required property var rootWindow

    spacing: 2

    Repeater {
        model: SystemTray.items
        WrapperMouseArea {
            id: trayIcon
            required property var modelData

            Layout.alignment: Qt.AlignVCenter
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: event => {
                if (event.button == Qt.LeftButton) {
                    modelData.activate();
                } else {
                    menuAnchor.menu = modelData.menu;
                    menuAnchor.open();
                }
            }

            QsMenuAnchor {
                id: menuAnchor
                anchor.window: tray.rootWindow
                anchor.rect.x: tray.parent.x + tray.x + trayIcon.x + trayIcon.width / 2
                anchor.rect.y: tray.rootWindow.implicitHeight
            }

            child: IconImage {
                source: trayIcon.modelData.icon
                implicitSize: 15
            }

            HoverHandler {
                onHoveredChanged: tooltipLoader.active = trayIcon.modelData.title.trim() !== "" && hovered
            }

            Loader {
                id: tooltipLoader
                active: false
                sourceComponent: TextTooltip {
                    rootWindow: tray.rootWindow
                    anchorItem: tray
                    text: trayIcon.modelData.title
                }
            }
        }
    }
}
