import QtQuick
import QtQuick.Window
import QtQuick.Controls
import DataSource 1.0

Window {
    maximumWidth: 360
    maximumHeight: 540
    minimumWidth: 360
    minimumHeight: 540
    visible: true
    title: qsTr("AudioShare")

    DataSource {
        id: dataSource
    }

    Rectangle {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: lastCheck.top

        BusyIndicator {
            anchors.centerIn: parent
            running: visible
            visible: dataSource.deviceState === 0
        }
        Text {
            anchors.centerIn: parent
            text: qsTr("没有找到设备")
            visible: dataSource.deviceState === 1
        }
        ListView {
            id: listView
            anchors.fill: parent
            model: dataSource
            spacing: 1
            visible: dataSource.deviceState === 2
            delegate: Rectangle {
                width: parent != null ? parent.width : 0
                height: 60
                color: "white"
                Image {
                    id: typeIcon
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    source: usbType ? "qrc:/image/assets/usbIcon.svg" : "qrc:/image/assets/wifiIcon.svg"
                }
                Column {
                    anchors.left: typeIcon.right
                    anchors.right: connectBtn.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 6
                    Text {
                        id: deviceName
                        text: `${manufacturer} ${deviceModel}`
                        font.pixelSize: 14
                        anchors.left: parent.left
                        anchors.right: parent.right
                        elide: Text.ElideRight
                    }
                    Text {
                        id: deviceVersion
                        text: `Android ${androidVersion}(API ${apiLevel})`
                              + (usbType ? "" : ` - ${ip}:${port}`)
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }
                }
                Button {
                    id: connectBtn
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    enabled: connectEnable
                    text: {
                        switch (connectState) {
                        case 0:
                            return "连接"
                        case 1:
                            return "连接中"
                        case 2:
                            return "断开"
                        }
                    }
                    onClicked: {
                        if (connectState === 0) {
                            dataSource.connectDevice(deviceId)
                        } else if (connectState === 2) {
                            dataSource.disconnectDevice(deviceId)
                        }
                    }
                }
            }
        }
    }
    CheckBox {
        id: lastCheck
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        text: "自动连接上次使用的设备"
        checked: dataSource.lastCheck
        onCheckedChanged: {
            dataSource.lastCheck = checked
        }
    }
}
