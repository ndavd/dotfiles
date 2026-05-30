pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    id: root

    signal dismissed

    readonly property int fontSize: 20
    readonly property int matchesCount: 10
    readonly property int iconSize: 25

    readonly property var filteredEntries: {
        const searchString = searchField.text.trim();
        if (searchString == "") {
            return [];
        }
        const matchingEntries = DesktopEntries.applications.values.map(app => {
            const value = matches(app.name, searchString);
            app["matchingValue"] = value;
            return app;
        }).filter(x => x.matchingValue != -1);
        matchingEntries.sort((a, b) => a.matchingValue - b.matchingValue);
        return matchingEntries;
    }

    property int selectedEntryIndex: 0

    readonly property int currentPage: Math.floor(selectedEntryIndex / matchesCount)

    function matches(name, searchString) {
        const searchParts = searchString.trim().toLowerCase().split(" ").filter(x => x !== "");
        if (searchParts.length == 0) {
            return -1;
        }
        const n = name.trim().toLowerCase();
        let position = 0;
        let value = 0;
        for (var i = 0; i < searchParts.length; i++) {
            const idx = n.indexOf(searchParts[i], position);
            if (idx == -1) {
                return -1;
            }
            value += idx;
            position = idx + searchParts[i].length;
        }
        return value;
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Component.onCompleted: {
        searchField.forceActiveFocus();
    }

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    color: Qt.rgba(Config.bg.r, Config.bg.g, Config.bg.b, 0.8)

    Rectangle {
        anchors.centerIn: parent
        width: root.width * 0.3
        height: root.height * 0.3
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent

            RowLayout {
                ThemedText {
                    text: "RUN:"
                    font.pixelSize: root.fontSize
                    font.bold: true
                }
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    color: Config.fg
                    selectionColor: Config.primary
                    font.pixelSize: root.fontSize
                    cursorDelegate: ThemedText {
                        text: "_"
                        font.pixelSize: parent.font.pixelSize
                        visible: parent.cursorVisible
                    }
                    background: Item {}
                    onTextChanged: root.selectedEntryIndex = 0
                    Keys.onReturnPressed: {
                        const app = root.filteredEntries[root.selectedEntryIndex];
                        Quickshell.execDetached(app.runInTerminal ? [Quickshell.env("TERMINAL"), "-e", app.command] : app.command);
                        root.dismissed();
                    }
                }
            }

            ColumnLayout {
                Layout.leftMargin: 20
                Repeater {
                    model: ScriptModel {
                        values: root.filteredEntries.map((_, i) => i).slice(root.currentPage * root.matchesCount, root.currentPage * root.matchesCount + root.matchesCount)
                    }
                    delegate: RowLayout {
                        id: entryArea
                        required property int modelData
                        spacing: 10

                        readonly property var entry: root.filteredEntries[modelData]

                        Image {
                            Layout.preferredWidth: root.iconSize
                            Layout.preferredHeight: root.iconSize
                            source: entryArea.entry?.icon ? Quickshell.iconPath(entryArea.entry.icon) : ""
                            fillMode: Image.PreserveAspectFit
                            sourceSize.width: root.iconSize
                            sourceSize.height: root.iconSize
                            visible: source !== ""
                        }
                        ThemedText {
                            text: entryArea.entry ? entryArea.entry.name : ""
                            font.pixelSize: root.fontSize
                            color: root.selectedEntryIndex == entryArea.modelData ? Config.primary : Config.fg
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+P"
        onActivated: root.selectedEntryIndex = Math.max(root.selectedEntryIndex - 1, 0)
    }
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: root.selectedEntryIndex = Math.min(root.selectedEntryIndex + 1, root.filteredEntries.length - 1)
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.dismissed()
    }
}
