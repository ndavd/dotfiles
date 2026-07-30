import QtQuick
import QtQuick.Layouts

ThemedText {
    Layout.leftMargin: Config.leftSideSpacing
    text: WindowTitleManager.text
    elide: Text.ElideRight
}
