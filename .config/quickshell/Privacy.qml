pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire

RowLayout {
    id: privacy

    required property var rootWindow

    property var audioInputApps: {
        return Pipewire.nodes.values.filter(n => n.type === PwNodeType.AudioInStream).map(n => n.properties["application.name"] ?? n.name);
    }

    property var audioOutputApps: {
        return Pipewire.nodes.values.filter(n => n.type === PwNodeType.AudioOutStream).map(n => n.properties["application.name"] ?? n.name);
    }

    property var screenshareApps: {
        return Pipewire.links.values.filter(l => l.source?.type === PwNodeType.VideoSource && l.state === PwLinkState.Active).map(l => l.target?.properties["application.name"] ?? l.target?.name ?? "");
    }

    property var icons: {
        return [
            {
                apps: screenshareApps,
                icon: "󱣴",
                color: "#cf5700"
            },
            {
                apps: audioOutputApps,
                icon: "",
                color: "#00b1d4"
            },
            {
                apps: audioInputApps,
                icon: "",
                color: "#1ca000"
            }
        ].filter(x => x.apps.length > 0);
    }

    visible: icons.length > 0

    PwObjectTracker {
        objects: Pipewire.links.values
    }

    Repeater {
        model: privacy.icons
        WrapperMouseArea {
            id: privacyIcon
            required property var modelData

            Layout.alignment: Qt.AlignVCenter

            ThemedText {
                opacity: 0.7
                font.pixelSize: Config.fontSize
                color: privacyIcon.modelData.color
                text: privacyIcon.modelData.icon
            }

            HoverHandler {
                onHoveredChanged: {
                    if (hovered) {
                        tooltip.visible = true;
                    } else {
                        tooltip.visible = false;
                    }
                }
            }

            TextTooltip {
                id: tooltip
                rootWindow: privacy.rootWindow
                anchorItem: privacy
                text: privacyIcon.modelData.apps.join("\n")
            }
        }
    }
}
