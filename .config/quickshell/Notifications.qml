import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications

PanelWindow {
    id: notif

    required property var modelData

    property bool isHovering: false

    property int iconSize: 15
    property int imageSize: 50
    property int iconSpacing: 5
    property int w: 400
    property int h: 90
    property int padding: 10

    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]

    anchors.top: true
    anchors.right: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.top: {
        const values = NotificationsManager.trackedNotifications.values;
        const index = values.length - 1 - values.indexOf(notif.modelData);
        return Config.h + index * (implicitHeight + 2);
    }
    implicitHeight: notif.h
    implicitWidth: notif.w

    property real rightMargin: 0

    WlrLayershell.margins.right: rightMargin

    NumberAnimation {
        target: notif
        property: "rightMargin"
        from: -notif.w
        to: 0
        duration: 10
        easing.type: Easing.OutCubic
        running: true
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Config.bg
        radius: 8
        border.color: modelData.urgency == NotificationUrgency.Critical ? "red" : Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.15)
        border.width: 1

        ColumnLayout {
            id: mainLayout
            spacing: 4
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: notif.padding

            RowLayout {
                RowLayout {
                    spacing: notif.iconSpacing

                    Rectangle {
                        Layout.preferredWidth: notif.iconSize
                        Layout.preferredHeight: notif.iconSize
                        color: "transparent"
                        ThemedText {
                            anchors.centerIn: parent
                            text: ""
                            font.pixelSize: 14
                            opacity: 0.8
                            visible: modelData.appIcon == ""
                        }
                        Image {
                            anchors.centerIn: parent
                            source: modelData.appIcon
                            fillMode: Image.PreserveAspectFit
                            sourceSize.width: notif.iconSize
                            sourceSize.height: notif.iconSize
                            visible: source !== ""
                        }
                    }

                    ThemedText {
                        text: modelData.appName
                        font.pixelSize: 11
                        opacity: 0.8
                    }
                }
                Item {
                    Layout.fillWidth: true
                }
                ThemedText {
                    text: NotificationsManager.notifTimes[modelData.id] ? Qt.formatTime(NotificationsManager.notifTimes[modelData.id], "HH:mm") : ""
                    font.pixelSize: 11
                    opacity: 0.8
                }
            }

            RowLayout {
                spacing: notif.padding
                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    spacing: 2

                    ThemedText {
                        text: modelData.summary
                        font.pixelSize: 14
                        font.bold: true
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }
                    ThemedText {
                        text: modelData.body
                        font.pixelSize: 13
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                }

                Image {
                    Layout.alignment: Qt.AlignTop
                    source: modelData.image
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: notif.imageSize
                    sourceSize.height: notif.imageSize
                    visible: source !== ""
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: modelData.dismiss()
        }
    }

    HoverHandler {
        onHoveredChanged: notif.isHovering = hovered
    }

    Timer {
        interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : 10000
        running: !notif.isHovering && !NotificationsManager.isIdle
        onTriggered: modelData.expire()
    }
}
