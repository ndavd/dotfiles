pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland

Singleton {
    id: root

    property bool loaded: false
    property bool locked: false

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    property var now: new Date()

    function lock() {
        root.locked = true;
        root.loaded = true;
    }

    function unlock() {
        root.locked = false;
        root.loaded = false;
        root.currentText = "";
        root.unlockInProgress = false;
    }

    function tryUnlock() {
        if (currentText === "") {
            return;
        }
        unlockInProgress = true;
        pam.start();
    }

    Timer {
        running: root.locked
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.now = new Date();
            interval = 60000 - (root.now.getSeconds() * 1000 + root.now.getMilliseconds());
        }
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            if (responseRequired) {
                respond(root.currentText);
            }
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.unlock();
            } else {
                root.currentText = "";
                root.showFailure = true;
                root.unlockInProgress = false;
            }
        }
    }

    // Force a load of a screencopy so the one in the lock works
    // https://github.com/caelestia-dots/shell/blob/2f7ab5e4140d9188185f6c3164e428c1eeda1fe6/modules/lock/Lock.qml#L29-L41
    Loader {
        active: true
        onLoaded: active = false
        sourceComponent: ScreencopyView {
            captureSource: Quickshell.screens[0]
        }
    }
}
