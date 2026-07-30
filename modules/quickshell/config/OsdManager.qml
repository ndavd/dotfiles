pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    enum OsdType {
        Volume = 0,
        Mute = 1,
        MicMute = 2,
        Brightness = 3
    }

    property bool visible: false
    property bool loaded: false

    property int currentType: OsdManager.OsdType.Volume

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var sinkAudio: sink?.audio
    readonly property real volume: Math.round((sinkAudio?.volume ?? 0) * 100)
    readonly property bool muted: sinkAudio?.muted ?? false

    readonly property var source: Pipewire.defaultAudioSource
    readonly property var sourceAudio: source?.audio
    readonly property bool micMuted: sourceAudio?.muted ?? false

    property real brightness: 0

    function load() {
        root.loaded = true;
        unloadTimer.restart();
    }

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    onVolumeChanged: {
        if (!sink?.ready) {
            return;
        }
        root.currentType = OsdManager.OsdType.Volume;
        load();
    }

    onMutedChanged: {
        if (!sink?.ready) {
            return;
        }
        root.currentType = OsdManager.OsdType.Mute;
        load();
    }

    onMicMutedChanged: {
        if (!source?.ready) {
            return;
        }
        root.currentType = OsdManager.OsdType.MicMute;
        load();
    }

    Process {
        command: ["ls", "/sys/class/backlight/"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const device = text.trim().split("\n")[0];
                if (!device) {
                    return;
                }
                brightnessFile.path = `/sys/class/backlight/${device}/brightness`;
                brightnessFile.watchChanges = true;
                brightnessFile.reload();
            }
        }
    }

    FileView {
        id: brightnessFile
        onLoaded: root.brightness = parseInt(text().trim())
        onFileChanged: {
            reload();
            root.currentType = OsdManager.OsdType.Brightness;
            root.load();
        }
    }

    readonly property int displayDuration: 2000
    readonly property int startupDelay: 4000

    Timer {
        id: unloadTimer
        interval: root.displayDuration
        onTriggered: root.loaded = false
    }

    Timer {
        interval: root.startupDelay
        running: true
        onTriggered: root.visible = true
    }
}
