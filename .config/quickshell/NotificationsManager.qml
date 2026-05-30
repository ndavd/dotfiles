pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

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

    readonly property alias trackedNotifications: notifServer.trackedNotifications
    readonly property int notificationCount: trackedNotifications.values.length
}
