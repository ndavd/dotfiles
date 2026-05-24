//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Wallpaper {}
    }
    Variants {
        model: Quickshell.screens
        delegate: StatusBar {}
    }
    Variants {
        model: NotificationsManager.trackedNotifications.values
        delegate: Notifications {}
    }
    Variants {
        model: Quickshell.screens
        delegate: Osd {}
    }

    Loader {
        id: launcher
        active: false
        sourceComponent: AppLauncher {}
        onLoaded: item.dismissed.connect(function () {
            launcher.active = false;
        })
    }
    IpcHandler {
        target: "launcher"
        function run() {
            launcher.active = true;
        }
    }
}
