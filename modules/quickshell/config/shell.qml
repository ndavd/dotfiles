//@ pragma UseQApplication
//@ pragma NativeTextRendering
//@ pragma DropExpensiveFonts
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Item {
            id: screenDelegate
            required property var modelData
            Wallpaper {
                screen: screenDelegate.modelData
            }
            StatusBar {
                screen: screenDelegate.modelData
            }
            Loader {
                id: osdLoader
                active: OsdManager.loaded
                sourceComponent: Osd {}
                onLoaded: item.screen = screenDelegate.modelData
            }
        }
    }

    Loader {
        active: LockManager.loaded
        sourceComponent: Lock {}
    }

    Loader {
        active: NotificationsManager.trackedNotifications.values.length > 0
        sourceComponent: Notifications {}
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            MemoryManager.update();
            CpuManager.update();
            DiskManager.update();
        }
    }

    Loader {
        id: launcherLoader
        active: false
        sourceComponent: AppLauncher {}
        onLoaded: item.dismissed.connect(function () {
            launcherLoader.active = false;
        })
    }

    IpcHandler {
        target: "launcher"
        function run() {
            launcherLoader.active = true;
        }
    }

    IpcHandler {
        target: "lock"
        function run() {
            LockManager.lock();
        }
    }
}
