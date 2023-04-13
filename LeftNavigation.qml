import QtQuick 2.15
import Skin 1.0
import QtGraphicalEffects 1.15
import "qrc:/CusWidgets" as CusWidgets
import "qrc:/Delegate" as Dele

Rectangle {
    id: root
    implicitWidth: 100
    implicitHeight: 400
    color: Skin.mainColor
    property int currentIndex: leftLV.currentIndex

    Column {
        anchors.fill: parent
        // 顶部头像
        Rectangle {
            id: headImgRect
            anchors.left: parent.left
            anchors.right: parent.right
            height: width / 1.2
            color: "transparent"

            CusWidgets.ImageButton {
                width: parent.width / 3
                height: width
                radius: width / 2
                anchors.centerIn: parent
                hoverColor: Qt.darker(Skin.mainColor)
                borderWidth: 2
            }
        }

        ListView {
            id: leftLV
            model: ListModel {
                ListElement {name: "视频播放"; iconPath: "qrc:/source/icons/videoplayer.png"}
                ListElement {name: "音频播放"; iconPath: "qrc:/source/icons/musicplayer.png"}
                ListElement {name: "基础设置"; iconPath: "qrc:/source/icons/setting.png"}
            }

            width: parent.width
            height: parent.height - headImgRect.height
            delegate: leftbar
            currentIndex: 0

            Component {
                id: leftbar
                Dele.LeftNaviDelegate {
                    width: ListView.view.width
                    height: 80
                }
            }
        }
    }
}
