import QtQuick 2.15
import Skin 1.0
import Config 1.0
import QtMultimedia 5.15
import "qrc:/CusWidgets" as CusWidgets

Item {
    id: root
    property int seclectedRow: -1
    property int margin: 15
    readonly property int order: 0
    readonly property int random: 1
    property int playMode: order
    property int lyricIdx: -1
    signal singerHeaderClicked()   // 点击歌手头像发出信号

    // 进度条
    CusWidgets.CusSlider {
        id: musicSlider
        height: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        value: musicPlayer.position / musicPlayer.duration
        onPositionChanged: {
            musicPlayer.seek(position * musicPlayer.duration)
        }
    }

    // 左边的歌曲基本信息
    Item {
        width: 200
        anchors.top: musicSlider.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.topMargin: root.margin
        anchors.bottomMargin: root.margin
        // 歌手头像
        CusWidgets.ImageButton {
            id: singerHeader
            width: parent.height
            height: parent.height
            source: "qrc:/source/images/defaultsinger.png"
            hoverSource: "qrc:/source/icons/expand.png"
            imageHoverColor: "#ddd"
            borderColor: Skin.mainColor
            borderWidth: 1
            radius: 5
            onClicked: {
                // 歌手头像被点击，显示歌词页面
                singerHeaderClicked()
            }
        }

        // 歌曲名
        Text {
            id: songName
            anchors.top: parent.top
            anchors.left: singerHeader.right
            anchors.right: parent.right
            height: contentHeight + 5
            color: Skin.textColor
            verticalAlignment: Text.AlignVCenter
            font.family: Config.fontFamily
            font.pixelSize: 18
            elide: Text.ElideRight   // 文字过长就用省略号代替
            leftPadding: 10
            text: root.seclectedRow===-1?"请选择音乐":myMusicPlayer.getMusicNameByRow(root.seclectedRow)
        }
        Text {
            id: singerName
            height: contentHeight + 5
            anchors.left: singerHeader.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            verticalAlignment: Text.AlignVCenter
            color: Qt.lighter(Skin.textColor, 1.4)
            font.family: Config.fontFamily
            elide: Text.ElideRight   // 文字过长就用省略号代替
            leftPadding: 10
            text: root.seclectedRow === -1 ?"未知歌手":"未知歌手"
        }
    }

    // 中间的播放、上一曲、下一曲等按钮
    Item {
        anchors.top: musicSlider.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: root.margin
        anchors.bottomMargin: root.margin
        Row {
            width: childrenRect.width
            height: parent.height
            anchors.centerIn: parent
            spacing: 20
            // 播放模式按钮（单曲循环、随机等模式）
            CusWidgets.ImageButton {
                width: parent.height *3 / 5 - 5
                height: width
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if (root.playMode === root.order) {
                        return "qrc:/source/icons/order.png"
                    } else {
                        return "qrc:/source/icons/random.png"
                    }
                }

                imageColor: Skin.currentTheme===1?Skin.textColor:Skin.mainColor
                imageHoverColor: Qt.darker(imageColor, 1.2)
                onClicked: {
                    if (root.playMode === root.order) {
                        root.playMode = root.random
                    } else {
                        root.playMode = root.order
                    }
                }
            }
            // 上一曲按钮
            CusWidgets.ImageButton {
                width: parent.height *3 / 5
                height: width
                radius: width / 2
                imagePadding: 10
                color: Skin.mainColor
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/source/icons/prev.png"
                imageColor: "white"
                imageHoverColor: "white"
                hoverColor: Qt.darker(Skin.mainColor, 1.2)
                onClicked: {
                    if (root.playMode === root.order) {  // 如果是顺序播放
                        if (root.seclectedRow !== -1) {
                            if (root.seclectedRow === 0) {
                                root.seclectedRow = myMusicPlayer.musicTableModel.rowCount() - 1
                            } else {
                                root.seclectedRow -= 1
                            }
                        } else {
                            root.seclectedRow = 0
                        }
                    } else { // 如果是随机播放
                        root.seclectedRow = getRandomNum(0, myMusicPlayer.musicTableModel.rowCount())
                    }
                }
            }
            // 播放按钮
            CusWidgets.ImageButton {
                width: parent.height * 3 / 4
                height: width
                radius: width / 2
                imagePadding: 10
                color: Skin.mainColor
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if (musicPlayer.playbackState !== MediaPlayer.PlayingState) {
                        return "qrc:/source/icons/play.png"
                    } else {
                        return "qrc:/source/icons/pause.png"
                    }
                }

                imageColor: "white"
                imageHoverColor: "white"
                hoverColor: Qt.darker(Skin.mainColor, 1.2)
                onClicked: {
                    if (musicPlayer.playbackState === MediaPlayer.PlayingState) {
                        musicPlayer.pause();
                    }
                    else {
                        musicPlayer.play();
                    }
                }
            }
            // 下一曲按钮
            CusWidgets.ImageButton {
                width: parent.height *3 / 5
                height: width
                radius: width / 2
                imagePadding: 10
                color: Skin.mainColor
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/source/icons/next.png"
                imageColor: "white"
                imageHoverColor: "white"
                hoverColor: Qt.darker(Skin.mainColor, 1.2)
                onClicked: {
                    if (root.playMode === root.order) { // 如果是顺序播放
                        if (root.seclectedRow !== -1) {
                            if (root.seclectedRow === myMusicPlayer.musicTableModel.rowCount()-1) {
                                root.seclectedRow = 0
                            } else {
                                root.seclectedRow += 1
                            }
                        } else {
                            root.seclectedRow = 0
                        }
                    } else { // 如果是随机播放
                        root.seclectedRow = getRandomNum(0, myMusicPlayer.musicTableModel.rowCount())
                    }

                }
            }
            // 音量
            CusWidgets.ImageButton {
                width: parent.height *3 / 5 - 5
                height: width
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/source/icons/volume_empty.png"
                imageColor: Skin.currentTheme===1?Skin.textColor:Skin.mainColor
                imageHoverColor: Qt.darker(imageColor, 1.2)
            }
        }
    }

    // 右边显示音频时长等
    Item {
        width: 200
        anchors.top: musicSlider.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: root.margin
        anchors.bottomMargin: root.margin

        Text {
            id: musicdurantion
            text: millisecondsToString(musicPlayer.position) + " / " + millisecondsToString(musicPlayer.duration)
            width:contentWidth
            height: parent.height
            font.pixelSize: 18
            font.family: Config.fontFamily
            color: Skin.textColor
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
        }
    }

    // 音频播放器(只要selectedRow改变了，MediaPlayer自然就会改变，因此
    // 切歌只需要想办法改变selectedRow就行)
    MediaPlayer {
        id: musicPlayer
        source: root.seclectedRow === -1 ? "" : myMusicPlayer.getMusicPathByRow(root.seclectedRow)
        onSourceChanged: {
            musicPlayer.play()
        }
        onStopped: { // 实现播放完成后自动切换下一首
            // 刚播放完和下一曲刚加载完成还没开始播放时都是处于stop状态
            if (musicPlayer.position !== 0) {  // position!==0说明是上一曲播放完成的状态，此时如果是顺序循环播放，则自动切换下一曲
                if (root.playMode === root.order) {
                    if (root.seclectedRow === myMusicPlayer.musicTableModel.rowCount()-1) {
                        root.seclectedRow = 0
                    } else {
                        root.seclectedRow += 1
                    }
                } else { // 如果是随机播放
                    root.seclectedRow = getRandomNum(0, myMusicPlayer.musicTableModel.rowCount())
                }
            }
        }
        onPositionChanged: {
            // 实时显示歌词
            var idx = myMusicPlayer.getLyricIdxByPosition(position)
            if (idx === -1) {
                root.lyricIdx = -1   // -1表示当前position没有合适的歌词
            } else {
                root.lyricIdx = idx
            }

        }
    }

    function millisecondsToString(time) {
        var milliseconds = time
        var minutes = Math.floor(milliseconds / 60000)
        milliseconds -= minutes * 60000
        var seconds = milliseconds / 1000
        seconds = Math.round(seconds)
        if (seconds < 10)
            return minutes + ":0" + seconds
        else
            return minutes + ":" + seconds
    }

    function getRandomNum(min, max) {
        // 返回[min, max)之间的整数
        var range= Math.max(0, max - min - 1);
        var rand = Math.random();
        return (min + Math.round(rand*range-1));
    }
}
