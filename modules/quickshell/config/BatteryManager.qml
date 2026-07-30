pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property var uPowerDevice: UPower.displayDevice
    readonly property int batteryPercentage: Math.round(uPowerDevice.percentage * 100)

    readonly property string text: batteryPercentage + "% " + ["", "", "", "", ""][Math.min(Math.floor(batteryPercentage / 20), 4)]
    readonly property color color: batteryPercentage <= 25 ? "red" : Config.fg
    readonly property string textSecondary: UPowerDeviceState.toString(uPowerDevice.state)
}
