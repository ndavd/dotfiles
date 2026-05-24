import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pipewire

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.bottom: 100
    implicitWidth: 300
    implicitHeight: Config.h
    anchors {
        bottom: true
    }
    color: Qt.rgba(Config.bg.r, Config.bg.g, Config.bg.b, 0.7)

    required property var modelData

    screen: modelData

    visible: false

    QtObject {
        id: osdType
        readonly property int volume: 0
        readonly property int mute: 1
        readonly property int micMute: 2
        readonly property int brightness: 3
    }

    property int currentType: osdType.volume

    property var sink: Pipewire.defaultAudioSink
    property var sinkAudio: sink?.audio
    property real volume: Math.round((sink?.audio?.volume ?? 0) * 100)
    property bool muted: sink?.audio?.muted ?? false

    property var source: Pipewire.defaultAudioSource
    property var sourceAudio: source?.audio
    property bool micMuted: sourceAudio?.muted ?? false

    PwObjectTracker {
        objects: [root.sink, root.source]
    }
    onVolumeChanged: {
        if (!sink?.ready) {
            return;
        }
        root.currentType = osdType.volume;
        root.show();
    }

    onMutedChanged: {
        if (!sink?.ready) {
            return;
        }
        root.currentType = osdType.mute;
        root.show();
    }

    onMicMutedChanged: {
        if (!source?.ready) {
            return;
        }
        root.currentType = osdType.micMute;
        root.show();
    }

    property real brightness: parseInt(brightnessFile.text().trim())

    Process {
        command: ["sh", "-c", "ls /sys/class/backlight/*/brightness"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                brightnessFile.path = this.text.trim();
                brightnessFile.watchChanges = true;
            }
        }
    }
    FileView {
        id: brightnessFile
        watchChanges: true
        onFileChanged: {
            this.reload();
            root.currentType = osdType.brightness;
            root.show();
        }
    }

    function show() {
        root.visible = true;
        hideTimer.restart();
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        ThemedText {
            text: {
                const vol = "VOL:";
                switch (root.currentType) {
                case osdType.volume:
                    return vol;
                case osdType.mute:
                    return root.muted ? "MUTED" : vol;
                case osdType.micMute:
                    return root.micMuted ? "MIC MUTED" : "MIC ON";
                case osdType.brightness:
                    return "BRI:";
                }
            }
            font.pixelSize: 16
            font.bold: true
        }
        Rectangle {
            Layout.preferredHeight: root.implicitHeight * 0.6
            Layout.preferredWidth: root.implicitWidth * 0.3
            color: Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.25)
            radius: 2

            Rectangle {
                height: parent.height
                width: parent.width * (root.currentType == osdType.brightness ? root.brightness : root.volume) / 100
                color: Config.fg
                radius: 2
            }
            visible: root.currentType == osdType.volume || (root.currentType == osdType.mute && !root.muted) || root.currentType == osdType.brightness
        }
        ThemedText {
            text: `${String(root.currentType == osdType.volume ? root.volume : root.brightness).padStart(3, ' ')}%`
            font.pixelSize: 16
            font.bold: true
            visible: root.currentType == osdType.volume || (root.currentType == osdType.mute && !root.muted) || root.currentType == osdType.brightness
        }
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.visible = false
    }
}
