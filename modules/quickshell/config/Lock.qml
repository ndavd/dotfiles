pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Wayland

WlSessionLock {
    id: root
    locked: LockManager.locked

    readonly property int clockFontSize: 120
    readonly property int dateFontSize: 30

    readonly property int inputWidth: 500
    readonly property int inputHeight: 70

    readonly property int inputFontSize: 25
    readonly property int symbolFontSize: 40

    readonly property int borderWidth: 3
    readonly property int borderRadius: 15

    property var now: new Date()

    Timer {
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.now = new Date();
            interval = 60000 - (root.now.getSeconds() * 1000 + root.now.getMilliseconds());
        }
    }

    WlSessionLockSurface {
        id: surface
        color: "transparent"

        ScreencopyView {
            id: screenCopy
            anchors.fill: parent
            captureSource: surface.screen
            live: false

            Timer {
                interval: 16
                repeat: true
                running: !screenCopy.hasContent
                onTriggered: screenCopy.captureFrame()
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                autoPaddingEnabled: false
                blurEnabled: true
                blur: 1
                blurMax: 0
                blurMultiplier: 1

                Component.onCompleted: blurMax = 64

                Behavior on blurMax {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.BlankCursor
        }

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            text: Qt.formatTime(root.now, "hh:mm")
            font.pixelSize: root.clockFontSize
            renderType: Text.NativeRendering
        }

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 150
            text: Qt.formatDate(root.now, "dddd, dd MMMM yyyy")
            font.pixelSize: root.dateFontSize
            renderType: Text.NativeRendering
        }

        ThemedText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2.5 * root.inputFontSize
            text: "LOCKED"
            font.pixelSize: root.inputFontSize
            renderType: Text.NativeRendering
        }

        Item {
            id: inputField

            anchors.centerIn: parent
            width: root.inputWidth
            height: root.inputHeight

            TextInput {
                id: passwordInput
                anchors.fill: parent
                opacity: 0
                focus: true
                enabled: !LockManager.unlockInProgress

                onTextChanged: {
                    if (LockManager.currentText !== text) {
                        LockManager.currentText = text;
                    }
                }

                onSelectedTextChanged: {
                    if (text.length > 0 && selectedText.length === text.length) {
                        LockManager.currentText = "";
                    }
                }

                Keys.onReturnPressed: LockManager.tryUnlock()
                Keys.onPressed: event => {
                    if (event.modifiers & Qt.ControlModifier && (event.key === Qt.Key_U || event.key === Qt.Key_Backspace)) {
                        LockManager.currentText = "";
                        event.accepted = true;
                    }
                }
            }

            Canvas {
                id: borderCanvas
                anchors.fill: parent
                Component.onCompleted: requestPaint()
                onWidthChanged: requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    const ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);
                    const h = Config.primary.hslHue, s = Config.primary.hslSaturation, l = Config.primary.hslLightness;
                    const colorA = Qt.hsla((h + 15 / 360) % 1, 1, 0.6, 1);
                    const colorB = Qt.hsla((h + 335 / 360) % 1, 1, 0.5, 1);
                    const colorC = Qt.hsla((h + 155 / 360) % 1, 1, 0.5, 1);
                    const colorD = Qt.hsla((h + 22 / 360) % 1, s, l * 0.83, 1);
                    const [c1, c2] = LockManager.showFailure ? [colorA, colorB] : LockManager.unlockInProgress ? [colorC, colorA] : [Config.primary, colorD];
                    const grad = ctx.createLinearGradient(0, height, width, 0);
                    grad.addColorStop(0, c1);
                    grad.addColorStop(1, c2);
                    ctx.strokeStyle = grad;
                    ctx.lineWidth = root.borderWidth;
                    const r = root.borderRadius, t = root.borderWidth / 2;
                    ctx.beginPath();
                    ctx.moveTo(r + t, t);
                    ctx.lineTo(width - r - t, t);
                    ctx.arcTo(width - t, t, width - t, r + t, r);
                    ctx.lineTo(width - t, height - r - t);
                    ctx.arcTo(width - t, height - t, width - r - t, height - t, r);
                    ctx.lineTo(r + t, height - t);
                    ctx.arcTo(t, height - t, t, height - r - t, r);
                    ctx.lineTo(t, r + t);
                    ctx.arcTo(t, t, r + t, t, r);
                    ctx.closePath();
                    ctx.stroke();
                }
            }

            Connections {
                target: LockManager
                function onCurrentTextChanged() {
                    if (passwordInput.text !== LockManager.currentText) {
                        passwordInput.text = LockManager.currentText;
                    }
                }
                function onShowFailureChanged() {
                    borderCanvas.requestPaint();
                }
                function onUnlockInProgressChanged() {
                    borderCanvas.requestPaint();
                }
            }

            Item {
                anchors.fill: parent
                anchors.margins: root.borderWidth
                clip: true

                Row {
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    visible: LockManager.currentText.length > 0
                    spacing: inputField.height * 0.2

                    Behavior on x {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.OutCubic
                        }
                    }

                    Repeater {
                        model: LockManager.currentText.length
                        delegate: ThemedText {
                            text: "*"
                            font.pixelSize: root.symbolFontSize
                            opacity: 0.6
                        }
                    }
                }

                ThemedText {
                    anchors.centerIn: parent
                    visible: LockManager.currentText.length === 0 && !LockManager.showFailure
                    text: "> PASSWORD <"
                    font.pixelSize: root.inputFontSize
                    opacity: 0.6
                }

                ThemedText {
                    anchors.centerIn: parent
                    visible: LockManager.showFailure
                    text: "INCORRECT"
                    color: "red"
                    font.pixelSize: root.inputFontSize
                }
            }
        }
    }
}
