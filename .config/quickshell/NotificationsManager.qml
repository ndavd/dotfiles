pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

Singleton {
    id: root

    property bool isIdle: false
    property var notifTimes: ({})

    NotificationServer {
        id: notifServer
        onNotification: notif => {
            if (notif.urgency == NotificationUrgency.Low) {
                return;
            }
            notif.tracked = true;
            const times = root.notifTimes;
            times[notif.id] = new Date();
            root.notifTimes = times;
        }
    }

    property alias trackedNotifications: notifServer.trackedNotifications

    IdleMonitor {
        timeout: 300
        onIsIdleChanged: {
            root.isIdle = isIdle;
        }
    }
}
