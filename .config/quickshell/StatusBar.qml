import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom

    required property var modelData

    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Config.h
    color: Config.bg

    RowLayout {
        anchors.fill: parent
        Layout.fillHeight: true
        spacing: 0

        RowLayout {
            spacing: Config.leftSideSpacing

            Workspaces {
                screen: root.modelData
            }

            WindowTitle {}
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: Config.rightSideSpacing

            Timer {
                interval: 30000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    mem.update();
                    cpu.update();
                    disk.update();
                }
            }

            Privacy {
                rootWindow: root
            }

            Submap {}

            PackageUpdates {
                rootWindow: root
            }

            Disk {
                id: disk
                rootWindow: root
            }

            Cpu {
                id: cpu
                rootWindow: root
            }

            Memory {
                id: mem
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
