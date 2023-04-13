pragma Singleton
import QtQuick 2.15

QtObject {
    property color mainColor: "#eee"
    property color background: "#f9f9f9"
    property color selectedColor: "#d5d5d5"
    property color iconColor: "#555"
    property color reserverColor: "#ffffff"
    property color textColor: "#555"
    property color hoverColor: "#ddd"
    property color splitColor: "gray"

    property int currentTheme: -1
    onCurrentThemeChanged: {
        var t = themes.get(currentTheme)
        mainColor = t.mainColor
        background = t.background
        textColor = t.textColor
        hoverColor = t.hoverColor
        selectedColor = t.selectedColor
        iconColor = t.iconColor
    }
    readonly property ListModel themes: ListModel {
        ListElement {
            name: qsTr("一品红")
            mainColor: "#da0606"
            background: "#fceaea"
            textColor: "#222"
            hoverColor: "#bf0404"
            selectedColor: "#bf0404"
            iconColor: "#222"
        }
        ListElement {
            name: qsTr("高冷黑")
            mainColor: "#191b1f"
            background: "#222"
            textColor: "#f6f6f6"
            hoverColor: "#111"
            selectedColor: "#111"
            iconColor: "#f6f6f6"
        }
        ListElement {
            name: qsTr("淑女粉")
            mainColor: "#faa0c5"
            background: "#fdf0f0"
            textColor: "#222"
            hoverColor: "#e999b4"
            selectedColor: "#e999b4"
            iconColor: "#222"
        }
        ListElement {
            name: qsTr("富贵金")
            mainColor: "#fed98f"
            background: "#f9f8e0"
            textColor: "#222"
            hoverColor: "#efb336"
            selectedColor: "#efb336"
            iconColor: "#222"
        }
        ListElement {
            name: qsTr(" 清爽绿")
            mainColor: "#58c979"
            background: "#e2fcd8"
            textColor: "#222"
            hoverColor: "#46a757"
            selectedColor: "#46a757"
            iconColor: "#222"
        }
        ListElement {
            name: qsTr("苍穹蓝")
            mainColor: "#67c1fd"
            background: "#d8f9fc"
            textColor: "#222"
            hoverColor: "#45a0db"
            selectedColor: "#45a0db"
            iconColor: "#222"
        }
    }
}
