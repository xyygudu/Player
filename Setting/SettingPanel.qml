import QtQuick 2.15
import Skin 1.0
import Config 1.0

Item {
    Text {
        id: noid
        anchors.centerIn: parent
        color: Skin.textColor
        font.family: Config.fontFamily
        font.pixelSize: 50
        text: "没写，懒得写!"
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: noid.bottom
        anchors.topMargin: 20
        color: Qt.lighter(Skin.textColor, 1.5)
        font.family: Config.fontFamily
        font.pixelSize: 25
        text: "主要是没什么可以设置的"
    }
}
