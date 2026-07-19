pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications

PanelWindow {
    id: root

    readonly property int iconSize: 15
    readonly property int imageSize: 50
    readonly property int iconSpacing: 5
    readonly property int w: 400
    readonly property int padding: 10
    readonly property int animDuration: 200

    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]

    anchors.top: true
    anchors.right: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.top: Config.statusBarHeight
    mask: Region {
        item: listView
    }
    implicitHeight: listView.contentHeight
    implicitWidth: w

    color: "transparent"

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight: contentHeight
        model: NotificationsManager.trackedNotifications
        verticalLayoutDirection: ListView.BottomToTop
        spacing: 2
        interactive: false

        add: Transition {
            NumberAnimation {
                property: "x"
                from: root.w
                to: 0
                duration: root.animDuration
                easing.type: Easing.OutCubic
            }
        }

        delegate: Rectangle {
            id: notif
            required property var modelData

            width: root.w
            height: mainLayout.implicitHeight + root.padding * 2

            color: Config.bg
            radius: 8
            border.color: modelData.urgency == NotificationUrgency.Critical ? "red" : Config.fgDim
            border.width: 1

            property bool isHovering: false

            ColumnLayout {
                id: mainLayout
                spacing: 4
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: root.padding

                RowLayout {
                    RowLayout {
                        spacing: root.iconSpacing

                        Rectangle {
                            Layout.preferredWidth: root.iconSize
                            Layout.preferredHeight: root.iconSize
                            color: "transparent"
                            ThemedText {
                                anchors.centerIn: parent
                                text: ""
                                font.pixelSize: 14
                                opacity: 0.8
                                visible: notif.modelData.appIcon == ""
                            }
                            Image {
                                anchors.centerIn: parent
                                source: notif.modelData.appIcon
                                fillMode: Image.PreserveAspectFit
                                sourceSize.width: root.iconSize
                                sourceSize.height: root.iconSize
                                visible: source !== ""
                            }
                        }

                        ThemedText {
                            text: notif.modelData.appName
                            font.pixelSize: 11
                            opacity: 0.8
                        }
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    ThemedText {
                        text: NotificationsManager.notifTimes[notif.modelData.id] ? Qt.formatTime(NotificationsManager.notifTimes[notif.modelData.id], "HH:mm") : ""
                        font.pixelSize: 11
                        opacity: 0.8
                    }
                }

                RowLayout {
                    spacing: root.padding
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        spacing: 2

                        ThemedText {
                            text: notif.modelData.summary
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }
                        ThemedText {
                            text: notif.modelData.body
                            font.pixelSize: 13
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            maximumLineCount: 4
                        }
                    }

                    Image {
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredWidth: root.imageSize
                        Layout.preferredHeight: root.imageSize
                        sourceSize.width: root.imageSize
                        sourceSize.height: root.imageSize
                        source: notif.modelData.image
                        fillMode: Image.PreserveAspectFit
                        visible: notif.modelData.image !== ""
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: notif.modelData.dismiss()
            }

            HoverHandler {
                onHoveredChanged: notif.isHovering = hovered
            }

            Timer {
                interval: notif.modelData.expireTimeout > 0 ? notif.modelData.expireTimeout : 10000
                running: !notif.isHovering && !IdleManager.isIdle
                onTriggered: notif.modelData.expire()
            }
        }
    }
}
