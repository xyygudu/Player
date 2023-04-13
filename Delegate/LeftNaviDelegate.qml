import QtQuick 2.15
import Skin 1.0
import Config 1.0
import QtGraphicalEffects 1.15

// 左侧导航栏的每一项
Rectangle {
    id: root
    color: {
        if (leftLV.currentIndex === index) {
            return Skin.hoverColor
        } else {
            if (mouseArea.containsMouse) {
                return Skin.hoverColor
            } else {
                return "transparent"
            }
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            leftLV.currentIndex = index
        }
    }

    Row {
        width: childrenRect.width
        height: 50
        anchors.centerIn: parent
        spacing: 10

        // 图标
        Image {
            id: itemIcon
            source: model.iconPath
            anchors.verticalCenter: parent.verticalCenter
            width: parent.height
            height: parent.height
            mipmap: true
            antialiasing: true
            // 设置图标颜色
            ColorOverlay {
                anchors.fill: itemIcon
                source: itemIcon
                color: Skin.iconColor
            }
        }

        // 图标对应的文字
        Text {
            id: itemText
            width: contentWidth
            height: parent.height
            text: model.name
            verticalAlignment: Text.AlignVCenter
            color: Skin.textColor
            font.pixelSize: 20
            font.family: Config.fontFamily
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
