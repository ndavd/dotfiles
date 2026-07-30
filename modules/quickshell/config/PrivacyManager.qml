pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    readonly property var icons: {
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

    readonly property bool visible: icons.length > 0

    PwObjectTracker {
        objects: Pipewire.links.values
    }

    readonly property var audioInputApps: {
        return Pipewire.nodes.values.filter(n => n.type === PwNodeType.AudioInStream).map(n => n.properties["application.name"] ?? n.name);
    }

    readonly property var audioOutputApps: {
        return Pipewire.nodes.values.filter(n => n.type === PwNodeType.AudioOutStream).map(n => n.properties["application.name"] ?? n.name);
    }

    readonly property var screenshareApps: {
        return Pipewire.links.values.filter(l => l.source?.type === PwNodeType.VideoSource && l.state === PwLinkState.Active).map(l => l.target?.properties["application.name"] ?? l.target?.name ?? "");
    }
}
