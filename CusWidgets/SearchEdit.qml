import QtQuick 2.15
import Skin 1.0
import Config 1.0

Rectangle {
    id: root
    width: 190
    height: 40
    border.width: 1
    radius: 10
    antialiasing: true
    property int iconWidth: 30
    color: Skin.background
    property color textColor: Skin.textColor
    border.color: Skin.currentTheme===1?Skin.textColor:Skin.mainColor
    signal clicked(string content)
    Row {
        padding: 5
        anchors.fill: parent
        TextInput {
            id: searchContent
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: root.width - 2 * parent.padding - searchBtn.width
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 10
            rightPadding: 10
            color: textColor
            clip: true
            font.family: Config.fontFamily

        }

        ImageButton {
            id: searchBtn
            width: parent.height - 2 * parent.padding
            height: width
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/source/icons/search.png"
            imageColor: Skin.currentTheme===1?Skin.textColor:Skin.mainColor
            imageHoverColor: Qt.darker(imageColor, 1.2)
            onClicked: {
                root.clicked(searchContent.text)
            }
        }
    }
}


