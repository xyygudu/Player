import QtQuick 2.0
import Skin 1.0
import QtQuick.Layouts 1.15
import "qrc:/Common" as Common
import "qrc:/MyVideo" as MyVideo
import "qrc:/MyMusic" as MyMusic
import "qrc:/Setting" as Setting


// 放置左侧导航栏选择后的所有控件

Item {
    id: root
    property int currentIndex: 0
    StackLayout {
        id: stacklayout
        anchors.fill: parent
        currentIndex: root.currentIndex

        MyVideo.VideoPanel {
            // 默认填充整个StackLayout，所以不用Layout.fillWidth: true
            implicitHeight: parent.height
            implicitWidth: parent.width
        }

        MyMusic.MusicPanel {
            // 当currentIndex不是MusicPanel是，MusicPanel默认宽度是0，
            // 即使后来currentIndex指向了MusicPanel，但是MusicPanel中表格的宽度并没有相应的调整不知到为什么，
            // 所以就提前把MusicPanel的宽高设置成父控件的宽高
            implicitHeight: parent.height
            implicitWidth: parent.width
        }

        // “设置”页面
        Setting.SettingPanel {

        }
    }
}
