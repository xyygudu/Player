import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "qrc:/CusWidgets" as CusWidgets
import "qrc:/TitleBar" as TitleBar
import Skin 1.0
import Config 1.0

Window {
    id: root
    width: 1225
    height: 765
    minimumWidth: 1225
    minimumHeight: 765
    visible: true
    title: qsTr("Hello World")
    color: "#00000000"  //设置窗口透明
    flags: Qt.FramelessWindowHint | Qt.Window
    property int margin: 15   // 阴影宽度
    Component.onCompleted: {
        Skin.currentTheme = 0
    }

    //阴影也要占地方，所以需要在主窗口套一个Rectangle，四周空出来绘制阴影
    Rectangle{
        id: mainRect
        anchors.fill: parent
        anchors.margins: root.visibility === Window.FullScreen ? 0 : root.margin  //设置四周空出来的宽度，这段宽度用于绘制阴影
        color: Skin.background
        radius: 5

        //如果其他控件有MouseArea中的事件，则其他控件要放在这个MouseArea后面，否则其他控件的MouseArea会被这里的MouseArea覆盖
        MouseArea{
            id: mouse
            anchors.fill: parent
            property int pressX
            property int pressY
            onPressed: {
                pressX = mouseX  //mouseX是QML提供的
                pressY = mouseY
            }
            onPositionChanged: {
                root.x += mouseX - pressX
                root.y += mouseY - pressY
            }
            onDoubleClicked: {
                root.visibility = root.visibility === Window.FullScreen ? Window.AutomaticVisibility : Window.FullScreen
            }
        }

        // 主面板控件放在下面
        LeftNavigation {
            id: leftbar
            anchors.left: parent.left
            height: parent.height
            width: Math.min(parent.width / 4.5, 300)
        }

        Column {
            // topbar标题栏
            anchors.top: parent.top
            anchors.left: leftbar.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            TitleBar.TopBar {
                id: titleBar
                windowVisibility: root.visibility
                width: parent.width
                height: 50
                onMaxWinClicked: {
                    root.visibility = root.visibility === Window.FullScreen ? Window.AutomaticVisibility : Window.FullScreen
                }
                onMinWinClicked: {
                    root.visibility = Window.Minimized
                }
            }
            // 主面板内容
            Content {
                id: content
                height: parent.height - titleBar.height
                width: parent.width / 1.2
                anchors.horizontalCenter: parent.horizontalCenter
                currentIndex: leftbar.currentIndex
            }
        }       
    }

    //绘制边框阴影
    DropShadow{
        anchors.fill: mainRect
        horizontalOffset: 0
        verticalOffset: 0
        radius: mouse.pressed ? 15 : 11  //阴影的半径，越大阴影越明显
        samples: 20
        source: mainRect
        color: "#666"
        Behavior on radius {
            PropertyAnimation{duration: 100}
        }
    }

    // 下面控件用于拖动伸缩窗口
    Item {//向左拖动
        id:leftSizeChange;
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: root.margin;
        visible: root.visibility === Window.FullScreen ? false : true

        MouseArea{
            anchors.fill:parent
            property point clickPos: "0,0"  //定义一个点
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                clickPos = Qt.point(mouseX, mouseY)
            }

            onPositionChanged: {  //属性的改变
                var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
                if((root.width-delta.x)>root.minimumWidth) {
                   root.setX(root.x+delta.x)
                   root.setWidth(root.width-delta.x)
                }
                else
                    root.setWidth(root.minimumWidth)
            }
        }
    }

    Item {//向下拖动
        id:downSizeChange
        anchors.bottom: parent.bottom
        anchors.left: leftSizeChange.right
        anchors.right: rightSizeChange.left
        height: root.margin
        visible: root.visibility === Window.FullScreen ? false : true

        MouseArea{  //设置可以拖动没有标题的登录界面.  /*这个要放在上面，放在最下面的话，会把上面全部屏蔽掉的*/
            anchors.fill:parent
            property point clickPos: "0,0"  //定义一个点
            cursorShape:Qt.SizeVerCursor
            onPressed: {
                clickPos = Qt.point(mouseX, mouseY)
            }

            onPositionChanged: {  //属性的改变
                var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
                if((root.height+delta.y)>root.minimumHeight)
//                        root.setHeight(root.height+delta.y)
                    root.height += delta.y
                else
                    root.setHeight(root.minimumHeight)
            }
        }
    }

    Item {//向右拖动
        id:rightSizeChange;
        width: root.margin
        anchors.right: parent.right
        anchors.top:parent.top
        anchors.bottom: parent.bottom
        visible: root.visibility === Window.FullScreen ? false : true

        MouseArea{
            anchors.fill:parent
            property point clickPos: "0,0"  //定义一个点
            cursorShape:Qt.SizeHorCursor
            onPressed: {
                clickPos = Qt.point(mouseX, mouseY)
            }

            onPositionChanged: {  //属性的改变
                var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
                if((root.width+delta.x)>root.minimumWidth) {
                   root.setWidth(root.width+delta.x)
                }
                else
                    root.setWidth(root.minimumWidth)
            }
        }
    }

    Item {//向上拖动
        id:upSizeChange
        anchors.bottom: mainRect.top
        anchors.left: leftSizeChange.right
        anchors.right: rightSizeChange.left
        height: root.margin
        visible: root.visibility === Window.FullScreen ? false : true

        MouseArea{
            anchors.fill:parent
            property point clickPos: "0,0"  //定义一个点
            cursorShape:Qt.SizeVerCursor
            onPressed: {
                clickPos = Qt.point(mouseX, mouseY)
            }

            onPositionChanged: {  //属性的改变
                var delta = Qt.point(mouseX-clickPos.x, mouseY-clickPos.y)
                if((root.height-delta.y)>root.minimumHeight) {
                    root.setY(root.y+delta.y)
                    root.setHeight(root.height-delta.y)
                }
                else
                    root.setHeight(root.minimumHeight)
            }
        }
    }
}
