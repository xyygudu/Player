import QtQuick 2.0
import "qrc:/CusWidgets" as CusWidgets
import Skin 1.0
import Config 1.0

Item {
    id: root
    width: 300
    height: 50
    property string path: ""
    signal searchClicked(string content)
    signal choosePathClicked(string path)
    Row  {
        anchors.fill: parent
        spacing: 20

    }
    CusWidgets.CusCombox {
        id: modeCombox
        width: 110
        height: 40
        anchors.verticalCenter: parent.verticalCenter
        onCurrentIndexChanged: {
            myMusicPlayer.setMode(currentIndex)
        }
    }

    CusWidgets.CusButton {
        id: openDirBtn
        text: "选择目录"
        width: 100
        height: 40
        anchors.leftMargin: 20
        anchors.left: modeCombox.right
        anchors.verticalCenter: parent.verticalCenter
        visible: modeCombox.currentIndex === 0 ? true : false

        onClicked: {
            choosePathClicked(currentPath.text)
        }
    }
    Text {
        id: currentPath
        text: root.path
        visible: modeCombox.currentIndex === 0 ? true : false
        anchors.leftMargin: 20
        anchors.left: openDirBtn.right
        anchors.right: searchEdit.left
        anchors.verticalCenter: parent.verticalCenter
        color: Skin.textColor
        font.family: Config.fontFamily
    }
    CusWidgets.SearchEdit {
        id: searchEdit
        width: 170
        height: 40
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.verticalCenter: parent.verticalCenter
        visible: modeCombox.currentIndex === 0 ? false : true
        onClicked: {
            root.searchClicked(content)  // content来自SearchEdit输入框的内容
        }
    }
}
