import QtQuick 2.15
import Qt.labs.qmlmodels 1.0
import Skin 1.0
import Config 1.0

// 用于呈现视频列表的信息

Item {
    id: root
    property variant columnWidths: [100,(width-300)*2/3, (width-300)/3, 200]
    signal doubleClicked(int row)
    property int fistColumnLeftPadding: 30
    // 表头（表格标题）
    Rectangle {
        id: tableHeader
        width: parent.width
        height: 50
        color: Skin.background
        Row {
            Repeater {
                model: myMusicPlayer.musicTableModel.headerDatas  // 使用tableView.column会出现Model size of -1 is less than 0
                Rectangle {
                    width: tableView.columnWidthProvider(index)+tableView.columnSpacing
                    height: tableHeader.height
                    color: "transparent"
                    Text {
                        text: modelData
                        anchors.left: parent.left
                        width: parent.width-15
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 10
                        font.family: Config.fontFamily
                        color: Skin.textColor
                        leftPadding:{
                            if (index === 0) return root.fistColumnLeftPadding
                            else return 0
                        }
                    }
                }
            }
        }
    }

    // 音乐列表视图
    TableView {
        id: tableView
        anchors.top: tableHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        implicitWidth: 100
        clip: true
        boundsBehavior: Flickable.StopAtBounds   // 关闭回弹效果
        property int selectedRow: -1   // 记录选中了哪一行
        columnWidthProvider: function(colum) { return root.columnWidths[colum] }
        onWidthChanged: {
            // If you change the values that a rowHeightProvider or a columnWidthProvider
            // return for rows and columns inside the viewport, you must call forceLayout.
            // This informs TableView that it needs to use the provider functions again to
            // recalculate and update the layout.
            forceLayout()
        }

        rowHeightProvider: function(row) { return 50 }

        model: myMusicPlayer.musicTableModel
        delegate: Rectangle {  // 每一个delegate只表示一个cell，列宽由columnWidthProvider指定
            implicitWidth: 50
            color: {
                if (model.row === tableView.selectedRow) {
                    return Skin.currentTheme===1?Qt.lighter(Skin.background, 1.8):Qt.darker(Skin.background, 1.05)
                }
                else {
                    return (model.row % 2) ? Skin.background : (Skin.currentTheme===1?Qt.lighter(Skin.background, 1.15):Qt.lighter(Skin.background, 1.04))
                }
            }

            Text {
                text: display
                anchors.left: parent.left
                width: parent.width-15
                anchors.verticalCenter: parent.verticalCenter
                color: Skin.textColor
                font.family: Config.fontFamily
                elide: Text.ElideRight   // 文字过长就显示省略号
                leftPadding: {
                    if (model.column === 0) {
                        return root.fistColumnLeftPadding
                    }
                    else {
                        return 0
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tableView.selectedRow = model.row
                }
                // 双击某行则触发信号，便于播放
                onDoubleClicked: {
                    root.doubleClicked(model.row)
                }
            }
        }
    }
}
