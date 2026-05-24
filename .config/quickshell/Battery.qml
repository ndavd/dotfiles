import QtQuick
import Quickshell.Services.UPower

ThemedText {
    id: battery

    required property var rootWindow

    property var uPowerDevice: UPower.displayDevice
    property int batteryPercentage: uPowerDevice.percentage.toFixed(2) * 100

    text: batteryPercentage + "% " + ["", "", "", "", ""][Math.min(Math.floor(batteryPercentage / 20), 4)]
    color: batteryPercentage <= 25 ? "red" : Config.fg

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
        rootWindow: battery.rootWindow
        anchorItem: battery
        text: UPowerDeviceState.toString(battery.uPowerDevice.state)
    }
}
