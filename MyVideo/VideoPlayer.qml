import QtQuick 2.15
import QtMultimedia 5.15
import "qrc:/CusWidgets" as CusWidgets
import Skin 1.0
// 视频播放器，用于播放视频

Rectangle {
    id: root
    color: "black"
    property string source: ""
    MediaPlayer {
        id: mediaplayer
        source: root.source
    }

    VideoOutput {
        anchors.fill: parent
        source: mediaplayer
    }

    MouseArea {
        id: playArea
        hoverEnabled: true
        anchors.fill: parent  // 相当于子控件anchors.fill: parent
        onClicked: {
            // 如果不是播放状态，那么就播放视频
            if (mediaplayer.playbackState !== MediaPlayer.PlayingState) {
                mediaplayer.play();
            } else {
                mediaplayer.pause();
            }
        }
        onPositionChanged: {
            // 当鼠标位置移动时，显示出控制视频的一系列控件（进度条、播放按钮、音量等）
            videoControlbar.visible = true
//            hideVideoCtrlBarTimer.running = true
        }

    }

    //底部控制视频的部件
    VideoControlBar {
        id: videoControlbar
        height: 80
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    // 加载完成就播放视频
    Component.onCompleted: {
        if (root.source !== "") {
            mediaplayer.play()
        }
    }
//    Timer {
//        id: hideVideoCtrlBarTimer
//        interval: 2000
//        repeat: false
//        running: false
//        triggeredOnStart: false // 是否开启定时就触发onTriggered
//        onTriggered: {
//            videoControlbar.visible = false
//        }
//    }
}


