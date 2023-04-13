import QtQuick 2.15
import QtGraphicalEffects 1.15
import Skin 1.0

Item {
    id: imgbthID
    implicitWidth: 30  //没有设置宽度时默认就是这个值
    implicitHeight: 30
    property int radius: 0
    property int borderWidth: 0
    property int imageHeight: Math.min(width, height)
    property int imageWidth: Math.min(width, height)
    property string source: "qrc:/source/images/default_image.png"
    property string hoverSource: ""
    property color color: "transparent"         // 背景色
    property color hoverColor: "transparent"   // 背景色
    property color borderColor: "transparent"
    property color imageColor: "transparent"
    property color imageHoverColor: "transparent"
    property int imagePadding: 0
    signal clicked()

    Rectangle{
        anchors.fill: parent
        border.width: imgbthID.borderWidth
        radius: imgbthID.radius
//        color: imgbthID.color
        color: {
            if (btnArea.containsMouse) {
                return imgbthID.hoverColor
            } else {
                return imgbthID.color
            }
        }

        border.color: {
            if (btnArea.containsMouse) {
                return imgbthID.imageHoverColor
            } else {
                return imgbthID.borderColor
            }
        }

        Image {
            id: image
            width: imgbthID.imageWidth - 2*imgbthID.borderWidth - imgbthID.imagePadding
            height: imgbthID.imageHeight - 2*imgbthID.borderWidth - imgbthID.imagePadding
            clip: true
            anchors.centerIn: parent
            source: {
                if (btnArea.containsMouse && imgbthID.hoverSource !== "") {
                    return imgbthID.hoverSource
                }
                return imgbthID.source
            }
            mipmap: true   // 有抗锯齿的作用
        }
        // 设置图标颜色
        ColorOverlay {
            id: imageColorOverlay
            anchors.fill: image
            source: image
            color: {
                if (btnArea.containsMouse) {
                    return imgbthID.imageHoverColor
                } else {
                    return imgbthID.imageColor
                }
            }
        }

        MouseArea{
            id: btnArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: imgbthID.clicked()  //发出图像点击信号
        }
    }

}
