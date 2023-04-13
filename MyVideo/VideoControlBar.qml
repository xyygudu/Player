import QtQuick 2.15
import Skin 1.0
import Config 1.0
import QtMultimedia 5.15
import "qrc:/CusWidgets" as CusWidgets

// 控制视频播放、显示播放进度等

Rectangle {
    id: root
    height: 80
    property real sliderValue: 0
    gradient: Gradient {
        GradientStop {  position: 0.0; color: "transparent"  }
        GradientStop {  position: 1.0; color: "black" }
    }
    Column {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        // 视频进度条
        CusWidgets.CusSlider {
            id: videoSlider
            width: parent.width
            height: 15
            value: mediaplayer.position / mediaplayer.duration
            onPositionChanged: {
                mediaplayer.seek(position * mediaplayer.duration)
            }
        }

        // 底部控制按钮（播放按钮、音量按钮等）
        Item {
            id: controlPanel
            width: parent.width
            height: parent.height - videoSlider.height
            property color iconColor: "#eee"
            property int btnWidth: height / 1.6   // 统一按钮宽度（高度）
            // 播放暂停按钮
            CusWidgets.ImageButton {
                id: playBtn
                width: parent.btnWidth
                height: width
                anchors.left: parent.left
                imageColor: parent.iconColor
                imageHoverColor: Qt.lighter(parent.iconColor, 1.2)
                anchors.verticalCenter: parent.verticalCenter
                source: {
                    if (mediaplayer.playbackState === MediaPlayer.PlayingState) {
                        return "qrc:/source/icons/pause.png"
                    }
                    else {
                        return "qrc:/source/icons/play.png"
                    }
                }
                onClicked: {
                    if (mediaplayer.playbackState === MediaPlayer.PlayingState) {
                        mediaplayer.pause();
                    }
                    else {
                        mediaplayer.play();
                    }
                }
            }

            // 显示已经播放时长/视频时长
            Text {
                id: videoDurationText
                color: parent.iconColor
                font.family: Config.fontFamily
                font.pixelSize: 20
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: playBtn.right
                anchors.leftMargin: 10
                text: millisecondsToString(mediaplayer.position) + " / " + millisecondsToString(mediaplayer.duration)
            }

            // 调节音量的控件
            Item {
                id: volumeItem
                width: 150
                height: parent.height
                anchors.right: parent.right
                // 音量图标按钮
                CusWidgets.ImageButton {
                    id: volumeBtn
                    width: controlPanel.btnWidth
                    imageColor: controlPanel.iconColor
                    imageHoverColor: Qt.lighter(controlPanel.iconColor, 1.2)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: valumeSlider.left
                    source: {
                        if (mediaplayer.muted) { // 如果静音了
                            return "qrc:/source/icons/mute.png"
                        } else {
                            return "qrc:/source/icons/volume.png"
                        }
                    }

                    onClicked: {
                        mediaplayer.muted = !mediaplayer.muted
                    }
                }
                CusWidgets.CusSlider {
                    id: valumeSlider
                    width: parent.width - volumeBtn.width
                    height: 12
                    value: 0.8
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    onPositionChanged: {
                        if (mediaplayer.muted) {
                            mediaplayer.muted = !mediaplayer.muted
                        }
                        mediaplayer.volume = value
                    }
                }
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
            return minutes + " : 0" + seconds
        else
            return minutes + " : " + seconds
    }
}
