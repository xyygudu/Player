import QtQuick 2.15
import QtQuick.Controls 2.15
import Skin 1.0
import Config 1.0

ComboBox {
    id: customComboBox
    model: ["本地模式", "线上模式"]
    currentIndex: 0
    font.family: Config.fontFamily
    width: 120
    height: 40

    // 自定义背景色和边框
    background: Rectangle {
        color: customComboBox.pressed ? Qt.darker(Skin.mainColor, 1.1): Skin.mainColor
        radius: 5
    }

    // 自定义箭头
    indicator: Image {
        source: "qrc:/source/icons/shrink.png"
        anchors.rightMargin: 10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        transform: Rotation {
            angle: customComboBox.opened ? 180 : 0
        }
    }

    // 自定义选项样式
    delegate: ItemDelegate {
        text: modelData
        width: parent.width
        height: 40
        highlighted: customComboBox.highlightedIndex === index
        background: Rectangle {
            color: highlighted ? Qt.darker(Skin.background, 1.1) : Skin.background
        }
    }
}
