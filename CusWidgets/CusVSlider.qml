import QtQuick 2.15
import QtQuick.Controls 2.15
import Skin 1.0

Slider {
     id: control
     value: 0
     snapMode: Slider.SnapOnRelease
     padding: 0
     orientation: Qt.Vertical
     property int sliderWidth: width / 2  // 可见的滑条的宽度（注意：不是Slider的宽度）
     property int circleWidth: width // 可拖动的圆形的直径
     background: Rectangle {
         x: control.leftPadding + control.availableWidth / 2 - sliderWidth / 2
         y: control.topPadding
         implicitWidth: control.sliderWidth
         implicitHeight: 200
         width: implicitWidth
         height: control.availableHeight
         radius: width / 2
         color: "#bdbebf"
         // 已经划过的部分
         Rectangle {
             x: 0
             y: parent.height - height
             width: parent.width
             height: control.position * parent.height
             color: Skin.mainColor
             radius: width / 2
         }
     }

     // 可拖动进度条圆形
     handle: Rectangle {
         x: control.leftPadding + control.availableWidth / 2 - width / 2
         y: control.topPadding + control.visualPosition *(control.availableHeight - height)
         implicitWidth: control.circleWidth
         implicitHeight: control.circleWidth
         radius: control.circleWidth / 2
         color: control.pressed ? Skin.mainColor : Skin.background
         border.width: control.pressed ? 0 : circleWidth/4
         border.color: Skin.mainColor
     }
 }
