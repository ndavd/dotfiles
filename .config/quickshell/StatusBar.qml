import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Config.statusBarHeight
    color: Config.bg

    RowLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            spacing: Config.leftSideSpacing

            Workspaces {
                screen: root.screen
            }

            WindowTitle {
                Layout.preferredWidth: Math.min(implicitWidth, root.width * 0.4)
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Config.rightSideSpacing

            Privacy {
                rootWindow: root
            }

            Submap {}

            PackageUpdates {
                rootWindow: root
            }

            Disk {
                rootWindow: root
            }

            Cpu {
                rootWindow: root
            }

            Memory {
                rootWindow: root
            }

            Battery {
                rootWindow: root
            }

            Clock {
                rootWindow: root
            }

            Tray {
                rootWindow: root
            }
        }
    }
}
