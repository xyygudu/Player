import QtQuick 2.15
import QtQuick.Controls 2.15
import Skin 1.0
import Config 1.0

Rectangle {
    id: root
    width: 140
    height: 40
    radius: 5
    color: btnArea.pressed ? Qt.darker(Skin.mainColor, 1.2) : (btnArea.containsMouse ? Qt.darker(Skin.mainColor, 1.1) : Skin.mainColor)
    property string text: "我是一个按钮"
    property color textColor: Skin.textColor
    signal clicked()
    Text {
        id: btnText
        anchors.centerIn: parent
        text: parent.text
        color: root.textColor
        font.family: Config.fontFamily
    }
    MouseArea {
        id: btnArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
        }
    }
}
