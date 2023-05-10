import QtQuick 2.15
import "qrc:/Common" as Common
// 放所有与音乐播放相关的控件
Item {
    id: root
    Column {
//        anchors.fill: parent
        anchors.top: parent.top
        anchors.bottom: musicControlBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        // 顶部的选择目录按钮和搜索框
        Common.ContentHeader {
            id: musicPanelHeader
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            path: myMusicPlayer.currentPath
            onSearchClicked: {
                // 处理搜索按钮点击事件
                myMusicPlayer.searchMusicOnline(content)
            }
            onChoosePathClicked: {
                // c++中的函数：把所选择路径下的音频信息更新到model中
                myMusicPlayer.updateMusicModel(path)
                musicControlBar.seclectedRow = -1 // 改变seclectedRow为-1相当于停止之前播放的歌曲
            }
        }

        MusicTable {
            id: musicTable
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height - musicPanelHeader.height
            onDoubleClicked: {
                myMusicPlayer.upDateLyricModelBy(row)
                musicControlBar.seclectedRow = row
            }
        }

    }

    MusicControlBar {
        id: musicControlBar
        width: parent.width
        height: 100
        anchors.bottom: parent.bottom
        onSingerHeaderClicked: {
            if (lyricsPanel.visible === true) {
                lyricsPanel.visible = false
            } else {
                lyricsPanel.visible = true
            }
        }
    }
    // 歌词界面
    LyricsPanel {
        id: lyricsPanel
        visible: false
        anchors.top: parent.top
        anchors.bottom: musicControlBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        lyricIndex: musicControlBar.lyricIdx
    }
}
