import QtQuick 2.15
import Config 1.0
import "qrc:/Common" as Common

// 放置顶部搜索框以及视频列表，即管理Common.ContentHeader.qml和VideoTable.qml

Item {
    id: root
    signal tableRowDoubleClicked(int row)
    Column {
        anchors.fill: parent
        // 顶部的选择目录按钮和搜索框
        Common.ContentHeader {
            id: contentHeader
            anchors.left: parent.left
            anchors.right: parent.right
            height: 60
            path: myVideoPlayer.currentPath
            onSearchClicked: {
                // 处理搜索按钮点击事件
            }
            onChoosePathClicked: {
                // c++中的函数：把所选择路径下的视频信息更新到model中
                myVideoPlayer.updateVideoModel(path)
            }
        }
        // 视频信息列表
        VideoTable {
            id: videoTable
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height - contentHeader.height
            onDoubleClicked: {
                root.tableRowDoubleClicked(row)
            }
        }
    }
}
