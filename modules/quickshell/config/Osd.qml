import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    readonly property int w: 300
    readonly property int bottomMargin: 100
    readonly property real bgOpacity: 0.7
    readonly property int osdFontSize: 16
    readonly property bool showValue: OsdManager.currentType == OsdManager.OsdType.Volume || (OsdManager.currentType == OsdManager.OsdType.Mute && !OsdManager.muted) || OsdManager.currentType == OsdManager.OsdType.Brightness

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.bottom: bottomMargin
    implicitWidth: w
    implicitHeight: Config.statusBarHeight
    anchors {
        bottom: true
    }
    color: Qt.rgba(Config.bg.r, Config.bg.g, Config.bg.b, bgOpacity)
    visible: OsdManager.visible

    RowLayout {
        anchors.centerIn: parent
        spacing: 8

        ThemedText {
            text: {
                const vol = "VOL:";
                switch (OsdManager.currentType) {
                case OsdManager.OsdType.Volume:
                    return vol;
                case OsdManager.OsdType.Mute:
                    return OsdManager.muted ? "MUTED" : vol;
                case OsdManager.OsdType.MicMute:
                    return OsdManager.micMuted ? "MIC MUTED" : "MIC ON";
                case OsdManager.OsdType.Brightness:
                    return "BRT:";
                }
            }
            font.pixelSize: osdFontSize
            font.bold: true
        }
        Rectangle {
            Layout.preferredHeight: root.implicitHeight * 0.6
            Layout.preferredWidth: root.implicitWidth * 0.3
            color: Qt.rgba(Config.fg.r, Config.fg.g, Config.fg.b, 0.25)
            radius: 2

            Rectangle {
                height: parent.height
                width: parent.width * (OsdManager.currentType == OsdManager.OsdType.Brightness ? OsdManager.brightness : OsdManager.volume) / 100
                color: Config.fg
                radius: 2
            }
            visible: root.showValue
        }
        ThemedText {
            text: `${String(OsdManager.currentType == OsdManager.OsdType.Volume ? OsdManager.volume : OsdManager.brightness).padStart(3, ' ')}%`
            font.pixelSize: osdFontSize
            font.bold: true
            visible: root.showValue
        }
    }
}
