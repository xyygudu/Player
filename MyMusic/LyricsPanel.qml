import QtQuick 2.15
import Skin 1.0
import Config 1.0

Rectangle {
    id: root
    // 左侧歌手头像部分
    color: Skin.background
    property int lyricIndex: -1
    Item {
        id: leftpanel
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        width: parent.width / 2
        // 歌手图像
        Image {
            id: songImage
            width: Math.min(parent.width/2, 250)
            height: width
            source: "qrc:/source/images/defaultsinger.png"
            anchors.centerIn: parent
        }
//        Text {
//            text: "正在播放：xxxxx"
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: songImage.bottom
//            anchors.topMargin: 15
//            width: contentWidth
//            height: contentHeight
//            font.family: Config.fontFamily
//            font.pixelSize: 18
//            color: Qt.lighter(Skin.textColor, 1.5)
//        }
    }
    // 右侧显示歌词部分
    Item {
        id: rightpanel
        anchors.right: parent.right
        anchors.left: leftpanel.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top

        ListView {
            id: lyricsList
            width: parent.width*2/3
            height: parent.height*3/4
            anchors.centerIn: parent
            model: myMusicPlayer.lyricModel
            spacing: 40
            preferredHighlightBegin: height / 2 - 10
            preferredHighlightEnd: height / 2 + 10
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            currentIndex: lyricIndex===-1?currentIndex:lyricIndex  // -1表示当前没有要显示的歌词，没有歌词显示就显示当前显示的那一句歌词

            delegate: Text {
                id: lyric
                text: display
                horizontalAlignment: Text.AlignHCenter
                width: lyricsList.width
                height: contentHeight
                color: {
                    if (lyricsList.currentIndex === index) {
                        if (Skin.currentTheme===1) {
                            return Skin.textColor
                        } else {
                            return Skin.mainColor
                        }
                    }  else {
                        if (Skin.currentTheme===1) {
                            return Qt.darker(Skin.textColor, 1.5)
                        } else {
                            return Skin.textColor
                        }
                    }
                }

                font.family: Config.fontFamily
                font.pixelSize: 18
            }

        }
    }

}
