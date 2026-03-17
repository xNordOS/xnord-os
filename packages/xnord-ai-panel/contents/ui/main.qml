import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: root
    Plasmoid.toolTipSubText: "Local AI assistant - Click to open"
    Plasmoid.icon: "preferences-desktop-locale"

    property string ollamaUrl: "http://127.0.0.1:11434"
    property bool isConnected: false
    property var messages: []

    ListModel {
        id: chatModel
    }

    function checkOllama() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                root.isConnected = (xhr.status === 200)
            }
        }
        xhr.open("GET", ollamaUrl + "/api/tags")
        xhr.send()
    }

    function sendMessage(text) {
        if (!text.trim()) return
        chatModel.append({ role: "user", content: text })
        var aidx = chatModel.count
        chatModel.append({ role: "assistant", content: "..." })
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var resp = JSON.parse(xhr.responseText)
                chatModel.setProperty(aidx, "content", resp.message ? resp.message.content : "Error")
            }
        }
        var msgs = []
        for (var i = 0; i < aidx; i++) {
            msgs.push({ role: chatModel.get(i).role, content: chatModel.get(i).content })
        }
        var body = JSON.stringify({ model: "llama3.2:3b", messages: msgs, stream: false })
        xhr.open("POST", ollamaUrl + "/api/chat")
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.send(body)
    }

    Component.onCompleted: checkOllama()

    Plasmoid.compactRepresentation: PlasmaComponents.Label {
        text: "AI"
        font.pixelSize: 12
        color: root.isConnected ? "#64748b" : "#94a3b8"
        MouseArea {
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
        }
    }

    Plasmoid.fullRepresentation: Item {
        width: 400
        height: 500
        Layout.minimumWidth: 400
        Layout.minimumHeight: 500

        ColumnLayout {
            anchors.fill: parent
            spacing: 8

            PlasmaComponents.Label {
                text: root.isConnected ? "x-Nord AI ready" : "Ollama not running. Run: ollama serve"
                color: root.isConnected ? "#74c365" : "#94a3b8"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }

            PlasmaComponents.Label {
                text: "Privacy: All data stays on your device."
                color: "#64748b"
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                ListView {
                    id: messageList
                    model: chatModel
                    delegate: Item {
                        width: messageList.width - 20
                        height: msgText.height + 16
                        PlasmaComponents.Label {
                            id: msgText
                            width: parent.width - 16
                            anchors.centerIn: parent
                            text: model.content
                            wrapMode: Text.WordWrap
                            color: "#f8fafc"
                            font.pixelSize: 12
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: inputField
                    Layout.fillWidth: true
                    placeholderText: "Ask x-Nord AI..."
                    onAccepted: {
                        root.sendMessage(text)
                        text = ""
                    }
                }
                Button {
                    text: "Send"
                    onClicked: {
                        root.sendMessage(inputField.text)
                        inputField.text = ""
                    }
                }
            }
        }
    }
}
