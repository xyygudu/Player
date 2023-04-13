import QtQuick 2.15
import QtQuick.Controls 2.15
import Skin 1.0

Slider {
     id: control
     value: 0
     snapMode: Slider.SnapOnRelease
     leftPadding: 0
     rightPadding: 0
//     stepSize: 0.02     // 把滑条分割成1/0.02=50等分
     property int sliderWidth: height / 2  // 可见的滑条的宽度（注意：不是Slider的宽度）
     property int circleWidth: height // 可拖动的圆形的直径
     background: Rectangle {
         x: control.leftPadding
         y: control.topPadding + control.availableHeight / 2 - height / 2
         implicitWidth: 200
         implicitHeight: control.sliderWidth
         width: control.availableWidth
         height: implicitHeight
         radius: 2
         color: "#bdbebf"
         // 已经划过的部分
         Rectangle {
             width: control.visualPosition * parent.width
             height: parent.height
             color: Skin.mainColor
             radius: 2
         }
     }

     // 可拖动进度条圆形
     handle: Rectangle {
         x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
         y: control.topPadding + control.availableHeight / 2 - height / 2
         implicitWidth: control.circleWidth
         implicitHeight: control.circleWidth
         radius: control.circleWidth / 2
         color: control.pressed ? Skin.mainColor : Skin.background
         border.width: control.pressed ? 0 : circleWidth/4
         border.color: Skin.mainColor
     }
 }
