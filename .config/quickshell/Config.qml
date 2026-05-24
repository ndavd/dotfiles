pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property int h: 20

    readonly property color bg: "#000000"
    readonly property color fg: "#ffffff"
    readonly property color primary: "#cf0704"

    readonly property string fontFamily: "monospace"
    readonly property int fontSize: 14

    readonly property int leftSideSpacing: 3
    readonly property int rightSideSpacing: 12
    readonly property int trayIconSize: 15
}
