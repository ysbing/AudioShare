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
        anchors.fill: parent
        color: "grey"
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
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    spacing: 6
                    Text {
                        id: deviceName
                        text: `${manufacturer} ${deviceModel}`
                        font.pixelSize: 14
                    }
                    Text {
                        id: deviceVersion
                        text: `Android ${androidVersion}(API ${apiLevel})`
                              + (usbType ? "" : ` - ${ip}:${port}`)
                        font.pixelSize: 12
                    }
                }
                Button {
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
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    enabled: connectEnable
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
}
