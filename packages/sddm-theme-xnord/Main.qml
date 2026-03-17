import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 1920
    height: 1080

    Rectangle {
        anchors.fill: parent
        color: config.BackgroundColor || "#0f172a"
    }

    Image {
        id: logoImage
        source: "logo-os.png"
        width: 120
        height: 120
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 120
    }

    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 80
        spacing: 30

        ComboBox {
            id: userSelect
            model: userModel
            textRole: "name"
            width: 300
            Layout.alignment: Qt.AlignHCenter
            currentIndex: userModel.lastIndex
        }

        TextField {
            id: passwordField
            width: 300
            echoMode: TextInput.Password
            placeholderText: "Password"
            Layout.alignment: Qt.AlignHCenter
            Keys.onReturnPressed: doLogin()
        }

        Button {
            text: "Login"
            width: 300
            Layout.alignment: Qt.AlignHCenter
            onClicked: doLogin()
        }

        ComboBox {
            id: sessionSelect
            model: sessionModel
            textRole: "name"
            width: 300
            Layout.alignment: Qt.AlignHCenter
            currentIndex: sessionModel.lastIndex
        }
    }

    function doLogin() {
        sddm.login(userSelect.currentText, passwordField.text, sessionSelect.currentIndex)
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {}
        function onLoginFailed() {
            passwordField.text = ""
            passwordField.focus = true
        }
    }
}
