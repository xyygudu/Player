import QtQuick 2.15
import QtQuick.Controls 2.15

// 放所有与视频相关的控件，一共两个页面，用stackview管理，
// 第一个页面是搜索框和视频列表，第二个页面是播放视频的控件

Item {
    id: root
    property int selectedRow: -1
    StackView {
        id: stackView
        anchors.fill: parent
        clip: true
        Component.onCompleted: {  // 使用initialItem显示的宽度为0，不知道为啥，下面方式等同于使用initialItem
            stackView.push(firstPage)
        }
    }

    Component {
        id: firstPage
        VideoFirstPage {
            onTableRowDoubleClicked: {
                root.selectedRow = row  // 将选中的行号赋值给root.selectedRow便于传入到secondPage中
                stackView.push(secondPage)   // 跳转到第二个页面(播放视频的页面)
            }
        }
    }

    Component {
        id: secondPage
        // 视频播放器（就是黑色的那个放视频的大矩形）
        VideoSecondPage {
            selectedRow: root.selectedRow
            onReturnBtnClicked: {
                stackView.pop()
            }
        }
    }
}
