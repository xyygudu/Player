import QtQuick 2.15
import Skin 1.0
import Config 1.0
import "qrc:/CusWidgets" as CusWidgets

// 播放视频的控件

Item {
    id: root
    property int selectedRow: -1
    signal returnBtnClicked()
    Column {
        anchors.fill: parent
        // 顶部返回按钮和标题显示
        Item {
            id: header
            width: parent.width
            height: 50
            anchors.left: parent.left
            anchors.right: parent.right
            // 返回按钮
            CusWidgets.ImageButton {
                id: returnBtn
                width: returnText.height
                height: returnText.height
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/source/icons/return.png"
                imageColor: Skin.textColor
                imageHoverColor: Qt.darker(imageColor, 1.5)
                onClicked: {
                    root.returnBtnClicked()
                }
            }
            Text {
                id: returnText
                text: qsTr("返回")
                color: Skin.textColor
                width: contentWidth
                height: contentHeight
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                font.family: Config.fontFamily
                verticalAlignment: Text.AlignVCenter
                anchors.left: returnBtn.right
            }

            Text {
                text: "正在播放：" + myVideoPlayer.getVideoNameByRow(root.selectedRow)
                color: Skin.textColor
                width: contentWidth
                height: contentHeight
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                font.family: Config.fontFamily
                verticalAlignment: Text.AlignVCenter  // 文字居中
                anchors.right: header.right
            }
        }

        // 视频播放器
        VideoPlayer {
            id: videoPlayer
            anchors.left: parent.left
            anchors.right: parent.right
            height: width * 9 / 16
            source: myVideoPlayer.getVideoPathByRow(root.selectedRow)
        }

        // 暂时没有什么可以实现，用个Rectangle占位
        Rectangle {
            id: bottomItem
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height-header.height-videoPlayer.height
            color: Skin.background
            Text {
                text: "可以放置视频的总览信息"
                font.pixelSize: 30
                font.family: Config.fontFamily
                color: Skin.textColor
                anchors.centerIn: parent
            }
        }

    }

}
