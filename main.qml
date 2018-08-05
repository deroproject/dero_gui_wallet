
// Copyright 2017-2018 DERO Project. All rights reserved.
// Use of this source code in any form is governed by GPL 3 license.
// license can be found in the LICENSE file.
// GPG: 0F39 E425 8C65 3947 702A  8234 08B2 0360 A03A 9DE8
//
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: window
    color: "#fffafafa"
    width: 660
    height: 520
    visible: true
    title: "DERO GUI Wallet (pre-alpha)"

    
       Settings {
        id: settings
        property string style: "Material"
    }
    
     Material.background: "#fafafa" 
    property string dbname: ""

    
    header: ToolBar {
        Material.foreground: "black"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                /*contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: stackView.depth > 1 ? "images/back.png" : "images/drawer.png"
                }*/
                text: "Logout"
                //visible:  stackView.depth > 1? true:false
                visible: ctxObject.wallet_valid == true ? true : false
                onClicked: {
                    ctxObject.closewallet()
                    titleLabel.text = "DERO GUI wallet"
                    // stackView.clear()
                    if (stackView.depth > 1) {
                        stackView.pop()
                        //  listView.currentIndex = -1
                    } /* else {
                                            drawer.open()
                                                                }*/
                }
            }

            Label {
                id: titleLabel
                //text: listView.currentItem ? listView.currentItem.text : "DERO GUI Wallet"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                //anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true

                // text: page.swipeView.contentChildren[page.swipeView.currentIndex].title
            }

            ToolButton {
                text: "MENU"
                /*contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }*/
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Settings"
                        onTriggered: settingsPopup.open()
                    }

                    MenuItem {
                        text: "Seed"
                        onTriggered: validateseedpasswordpopop.open()
                        height: ctxObject.wallet_valid == true ? implicitHeight : 0
                    }
                    
                    
                    MenuItem {
                        text: "Change Password"
                        onTriggered: changepasswordpopop.open()
                        height: ctxObject.wallet_valid == true ? implicitHeight : 0
                    }
                    
                    
                    
                    MenuItem {
                        text: "Logout " 
                        height: ctxObject.wallet_valid == true ? implicitHeight : 0

                        onTriggered: {
                            ctxObject.closewallet()
                            titleLabel.text = "DERO GUI wallet"
                            // stackView.clear()
                            if (stackView.depth > 1) {
                                stackView.pop()
                                //  listView.currentIndex = -1
                            }
                        }
                    }

                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }

                    
                    MenuItem {
                        text: "Exit"

                        onTriggered: {
                            Qt.quit()
                        }
                    }
                }
            }
        }
    }

    
    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane

            // anchors.fill: parent
            Column {
                spacing: 10
                anchors.fill: parent

                //Layout.fillWidth: true
                //Layout.alignment: Qt.AlignHCenter
                Rectangle {
                    id: logorect
                    width: 100
                    height: 100
                    //Layout.alignment: Qt.AlignHCenter
                    //anchors.left: parent.Left+100 //((parent.right - parent.left) - 100) /2
                    anchors.horizontalCenter: parent.horizontalCenter

                    // anchors.fill: parent
                    // anchors.centerIn: parent
                    Image {
                        id: logo
                        //width: pane.availableWidth / 2
                        // height: pane.availableHeight / 2

                        // horizontalAlignment: Image.AlignHCenter
                        width: 64
                        height: 64

                        anchors.fill: parent
                        anchors.centerIn: parent
                        //  anchors.verticalCenterOffset: -50
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/dero-front-logo.png"
                    }
                }

                Rectangle {
                    id: placeholder
                    height: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: openexisting
                    text: "Open Existing DERO Wallet"
                    // anchors.centerIn: parent
                    anchors.topMargin: 40
                   // anchors.top: logorect.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Layout.horizontalAlignment: Qt.AlignHCenter
                    // Layout.alignment: Qt.AlignHCenter
                    onClicked: {
                        walletfileopendialog.open()
                    }

                    Material.foreground: Material.Primary
                    //Material.background: "transparent"
                    Material.elevation: 2


                    // Layout.preferredWidth: 0
                    // Layout.fillWidth: true
                    FileDialog {
                        id: walletfileopendialog

                        title: "Please choose DERO wallet db"
                        selectExisting: true
                        selectMultiple: false
                        folder: shortcuts.home
                        nameFilters: ["DERO wallet file (*.db)"]
                        onAccepted: {
                            console.log("You chose: " + walletfileopendialog.fileUrl)
                            window.dbname = walletfileopendialog.fileUrl.toString()
                            window.dbname = window.dbname.replace(
                                        /^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,
                                        "") // remove prefixed "file:///"
                            window.dbname = decodeURIComponent(
                                        window.dbname) // unescape html codes like '%23' for '#'

                            console.log("window.dbname: " + window.dbname)
                            openpassworddialog.open()
                            //  Qt.quit()
                        }
                        onRejected: {
                            console.log("Canceled")
                            // Qt.quit()
                        }
                        // Component.onCompleted: visible = true
                    }
                }

                Button {
                    id: createnew
                    text: "Create new DERO Wallet"

                  //  anchors.top: openexisting.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: {
                        walletfilenewdialog.open()
                    }

                    Material.foreground: Material.Primary
                    //Material.background: "transparent"
                    Material.elevation: 2


                    //  Layout.preferredWidth: 0
                    //  Layout.fillWidth: true
                    FileDialog {
                        id: walletfilenewdialog

                        title: "Please choose a folder to save wallet.db"
                        selectExisting: true
                        selectFolder: true
                        selectMultiple: false
                        folder: shortcuts.home
                        nameFilters: ["DERO wallet file (*.db)"]
                        onAccepted: {
                            console.log("You chose: folder " + walletfilenewdialog.folder)
                            console.log("You chose: file " + walletfilenewdialog.fileUrl)
                            window.dbname = walletfilenewdialog.folder.toString(
                                        )
                            window.dbname = window.dbname.replace(
                                        /^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,
                                        "") // remove prefixed "file:///"
                            window.dbname = decodeURIComponent(
                                        window.dbname) // unescape html codes like '%23' for '#
                            createnewpopup.open()
                            //  Qt.quit()
                        }
                        onRejected: {
                            console.log("Canceled new wallet")
                            // Qt.quit()
                        }
                        // Component.onCompleted: visible = true
                    }
                }

                Button {
                    id: recoverseed
                    text: "Recover DERO Wallet using seed"
                  //  anchors.top: createnew.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: {
                        walletfilerecoverseeddialog.open()
                    }

                    Material.foreground: Material.Primary
                    //Material.background: "transparent"
                    Material.elevation: 2


                    //  Layout.preferredWidth: 0
                    //  Layout.fillWidth: true
                    FileDialog {
                        id: walletfilerecoverseeddialog

                        title: "Please choose a file to save wallet.db"
                        selectExisting: true
                        selectFolder: true
                        selectMultiple: false
                        folder: shortcuts.home
                        nameFilters: ["DERO wallet file (*.db)"]
                        onAccepted: {
                            console.log("You chose: " + walletfilerecoverseeddialog.folder)
                            window.dbname = walletfilerecoverseeddialog.folder.toString()
                            window.dbname = window.dbname.replace(
                                        /^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,
                                        "") // remove prefixed "file:///"
                            window.dbname = decodeURIComponent(
                                        window.dbname) // unescape html codes like '%23' for '#
                            recoverseedwordspopup.open()
                        }
                        onRejected: {
                            console.log("Canceled")
                            // Qt.quit()
                        }
                        // Component.onCompleted: visible = true
                    }
                }

                Button {
                    id: recoverkey
                  //  anchors.top: recoverseed.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Recover wallet using Key"
                    onClicked: {
                        walletfilerecoverkeydialog.open()
                    }

                    Material.foreground: Material.Primary
                    //Material.background: "transparent"
                    Material.elevation: 2


                    //  Layout.preferredWidth: 0
                    //  Layout.fillWidth: true
                    FileDialog {
                        id: walletfilerecoverkeydialog

                        title: "Please choose a file to save wallet.db"
                        selectExisting: true
                        selectFolder: true
                        selectMultiple: false
                        folder: shortcuts.home
                        nameFilters: ["DERO wallet file (*.db)"]
                        onAccepted: {
                            console.log("You chose: " + walletfilerecoverkeydialog.folder)
                            window.dbname = walletfilerecoverkeydialog.folder.toString()
                            window.dbname = window.dbname.replace(
                                        /^(file:\/{2})|(qrc:\/{2})|(http:\/{2})/,
                                        "") // remove prefixed "file:///"
                            window.dbname = decodeURIComponent(
                                        window.dbname) // unescape html codes like '%23' for '#

                            recoverkeypopup.open()
                            //  Qt.quit()
                        }
                        onRejected: {
                            console.log("Canceled")
                            // Qt.quit()
                        }
                        // Component.onCompleted: visible = true
                    }
                }

                /*Image {
                id: arrow
                source: "qrc:/images/arrow.png"
                anchors.left: parent.left
                anchors.bottom: parent.bottom
            }*/
            }

            Label {
                text: "© 2018,  DERO Foundation. All rights reserved.\n"
                      + "Use of this program is governed under DERO research license.\n"
                      + "version " + ctxObject.version

             //   anchors.margins: 20
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.top: parent.bottom
                //anchors.left: parent.left
                //anchors.right: parent.right
                anchors.bottom: parent.bottom
                horizontalAlignment: Label.AlignHCenter
                //verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }
        }
    }

    Popup {
        id: openpassworddialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - openpasswordColumn.height) / 2

        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: openpasswordColumn.height

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }
        background: Rectangle {  color: window.color; }

        Column {
            id: openpasswordColumn
            spacing: 20

            Label {
                text: "Enter Password for " + window.dbname
                width: openpassworddialog.width
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: openpassword
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Button {

                text: "OK"

                // isDefault: true
                onClicked: {

                    console.log("dbname: " + dbname)
                    console.log("window.dbname: " + window.dbname)
                    ctxObject.initerr = ""
                    ctxObject.openwallet(window.dbname, openpassword.text)

                    if (ctxObject.initerr != "") {
                        ToolTip.delay = -1
                        ToolTip.timeout = 10000
                        ToolTip.text = ctxObject.initerr

                        ToolTip.visible = true
                    } else {
                        // if successfull
                        openpassworddialog.close()

                        // clean up text fields
                        openpassword.text = ""
                        stackView.push("qrc:/mainwallet.qml")
                        setwalletmode() // make wallet online/offline
                    }
                }
            }

            Button {
                text: "Cancel"
                onClicked: {
                    openpassworddialog.close()
                }
            }
        }
    }

    Popup {
        id: createnewpopup
        modal: true
        focus: true

        x: (window.width - width) / 2
        y: (window.height - createnewColumn.height) / 2
        width: Math.min(window.width, window.height) / 3 * 2
        
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }
        background: Rectangle {  color: window.color; }

        Column {
            id: createnewColumn
            spacing: 5

            Label {
                text: "Enter Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: createnewpass
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Label {

                text: "Confirm Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: createnewpassconfirm
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                //isDefault: true
                enabled: createnewpass.text == createnewpassconfirm.text ? true : false
                onClicked: {

                    console.log("dbname: " + dbname)
                    console.log("window.dbname: " + window.dbname)

                    ctxObject.initerr = ""
                    ctxObject.createnewwallet(window.dbname, createnewpass.text)

                    if (ctxObject.initerr != "") {

                        ToolTip.delay = -1
                        ToolTip.timeout = 10000
                        ToolTip.text = ctxObject.initerr

                        ToolTip.visible = true
                    } else {
                        // if successfull
                        createnewpopup.close()


                        // clean up text fields
                        createnewpass.text = ""
                        createnewpassconfirm.text = ""
                        stackView.push("qrc:/mainwallet.qml")
                        seedPopup.open() // mandatory show seed
                        setwalletmode() // make wallet online/offline
                    }
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Cancel"
                onClicked: {
                    createnewpopup.close()
                }
            }
        }
    }

    Popup {
        id: recoverseedwordspopup
        modal: true
        focus: true

        x: (window.width - width) / 2
        y: (window.height - recoverseedwordsColumn.height) / 2
        width: Math.min(window.width, window.height) / 3 * 2

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }
        background: Rectangle {  color: window.color; }

        Column {
            id: recoverseedwordsColumn
            spacing: 5

            Label {
                text: "25 Seed Words"
                font.bold: true
            }

            TextField {
                id: recoverseedwordstext
                wrapMode: Label.Wrap
                width: recoverseedwordspopup.width - 20
                placeholderText: qsTr("25 seed words")
            }

            Label {
                text: "Enter Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: recoverseedwordspass
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Label {

                text: "Confirm Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: recoverseedwordspassconfirm
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                //isDefault: true
                enabled: recoverseedwordspass.text
                         == recoverseedwordspassconfirm.text ? true : false
                onClicked: {

                    console.log("dbname: " + dbname)
                    console.log("window.dbname: " + window.dbname)

                    ctxObject.initerr = ""
                    ctxObject.recoverusingseedwords(window.dbname,
                                                    recoverseedwordspass.text,
                                                    recoverseedwordstext.text)

                    if (ctxObject.initerr != "") {

                        ToolTip.delay = -1
                        ToolTip.timeout = 5000
                        ToolTip.text = ctxObject.initerr

                        ToolTip.visible = true
                    } else {
                        // if successfull
                        recoverseedwordspopup.close()

                        // clean up text fields
                        recoverseedwordstext.text = ""
                        recoverseedwordspass.text = ""
                        recoverseedwordspassconfirm.text = ""
                        stackView.push("qrc:/mainwallet.qml")
                        setwalletmode() // make wallet online/offline
                    }
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Cancel"
                onClicked: {
                    recoverseedwordspopup.close()
                }
            }
        }
    }

    Popup {
        id: recoverkeypopup
        modal: true
        focus: true

        x: (window.width - width) / 2
        y: (window.height - recoverkeyColumn.height) / 2
        width: Math.min(window.width, window.height) / 3 * 2
        // contentHeight: recoverkeyColumn.height
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }
        
        background: Rectangle {  color: window.color; }

        Column {
            id: recoverkeyColumn
            spacing: 5

            Label {
                text: "Recover Key"
                font.bold: true
            }

            TextField {
                id: recoverkeytext
                wrapMode: Label.Wrap
                width: recoverkeypopup.width - 20
                placeholderText: qsTr("Recovery Key")
            }

            Label {
                text: "Enter Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: recoverkeypass
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Label {

                text: "Confirm Password"
                wrapMode: Label.Wrap
                font.bold: true
            }

            TextField {
                id: recoverkeypassconfirm
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "OK"
                //isDefault: true
                enabled: recoverkeypass.text == recoverkeypassconfirm.text ? true : false
                onClicked: {

                    console.log("dbname: " + dbname)
                    console.log("window.dbname: " + window.dbname)

                    ctxObject.initerr = ""
                    ctxObject.recoverusingkey(window.dbname,
                                              recoverkeypass.text,
                                              recoverkeytext.text)

                    if (ctxObject.initerr != "") {

                        ToolTip.delay = -1
                        ToolTip.timeout = -1
                        ToolTip.text = ctxObject.initerr

                        ToolTip.visible = true
                    } else {
                        // if successfull
                        recoverkeypopup.close()

                        // clean up text fields
                        recoverkeytext.text = ""
                        recoverkeypass.text = ""
                        recoverkeypassconfirm.text = ""
                        stackView.push("qrc:/mainwallet.qml")
                        setwalletmode() // make wallet online/offline
                    }
                }
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Cancel"
                onClicked: {
                    recoverkeypopup.close()
                }
            }
        }
    }

    // this function will set the wallet mode, online or offline of custom server
    function setwalletmode() {

        if (ctxObject.wallet_valid == true) {
            
            
            // change status if wallet is open
            if (settings_online_remote.checked == true) {
                
                if (ctxObject.remote_server == "") { // if empty choo
                            ctxObject.remote_server = remote_server.textAt(remote_server.currentIndex);
                        }
                        
                // wallet set custom remote server
                ctxObject.setwalletonline(ctxObject.remote_server)
            }

            if (settings_online_local.checked == true) {
                ctxObject.setwalletonline(ctxObject.remote_server)
            }

            // make sure wallet is offline
            if (settings_online_remote.checked == false
                    && settings_online_local.checked == false) {
                ctxObject.setwalletoffline()
            }
        }
    }


    /*
    // custom combobox to fit in max width element
    ComboBox {
    id: control

    property bool sizeToContents
    property int modelWidth

    width: (sizeToContents) ? modelWidth + 2*leftPadding + 2*rightPadding : implicitWidth

    delegate: ItemDelegate {
        width: control.width
        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        font.weight: control.currentIndex === index ? Font.DemiBold : Font.Normal
        font.family: control.font.family
        font.pointSize: control.font.pointSize
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    TextMetrics {
        id: textMetrics
    }

    onModelChanged: {
        textMetrics.font = control.font
        for(var i = 0; i < model.length; i++){
            textMetrics.text = model[i]
            modelWidth = Math.max(textMetrics.width, modelWidth)
        }
    }
} */
    
    
    Popup {
        id: changepasswordpopop
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - changepasswordColumn.height) / 2

        background: Rectangle {  color: window.color; }
        
        width: window.width * 4 / 5 // 80 %
        contentHeight: changepasswordColumn.height

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }

        Column {
            id: changepasswordColumn
            spacing: 10
            width: parent.width
            
            Text {
                text: "Enter Current Password"
                wrapMode: Label.Wrap
                //font.bold: true
            }
            
            TextField {
                id: currentpassword
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }
            
            
            Text {
                text: "Enter new password"
                wrapMode: Label.Wrap
                //font.bold: true
            }
            
            TextField {
                id: newpassword
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
                onTextChanged: {
                            if (newpassword.text === newpassword1.text) {
                                changepasswordokbutton.enabled = true;
                            } else {
                                changepasswordokbutton.enabled = false;
                            }
                }
            }

            Text {
                text: "Confirm new password"
                wrapMode: Label.Wrap
                //font.bold: true
            }

            TextField {
                id: newpassword1
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
                onTextChanged: {
                            if (newpassword.text === newpassword1.text) {
                                changepasswordokbutton.enabled = true;
                            } else {
                                changepasswordokbutton.enabled = false;
                            }
                }
            }

            Row {
                Button {
                    id: changepasswordokbutton

                    text: "OK"
                    

                    // isDefault: true
                    onClicked: {

                        ctxObject.initerr = ""
                        ctxObject.checkpassword(currentpassword.text)

                        if (ctxObject.initerr != "") {
                            ToolTip.delay = -1
                            ToolTip.timeout = 5000
                            ToolTip.text = "Invalid Password."

                            ToolTip.visible = true
                        } else {
                            
                            ctxObject.initerr = ""
                            
                            ctxObject.setpassword(currentpassword.text, newpassword.text)

                        if (ctxObject.initerr != "") {
                            ToolTip.delay = -1
                            ToolTip.timeout = 5000
                            ToolTip.text = ctxObject.initerr

                            ToolTip.visible = true
                        } else {
                            
                            
                            // clean up text fields
                            currentpassword.text = ""
                            newpassword.text = ""
                            newpassword1.text = ""
                            
                            ToolTip.delay = -1
                            ToolTip.timeout = 5000
                            ToolTip.text = "Password changed successfully."

                            ToolTip.visible = true

                            // if successfull
                            changepasswordpopop.close()
                            
                            
                            
                        }
                        }
                    }
                }
                Text {
                    text: "    "
                }

                Button {
                    text: "Cancel"
                    onClicked: {
                        changepasswordpopop.close()
                    }
                }
            }
        }
    }
    
    
    Popup {
        id: validateseedpasswordpopop
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - validateseedpasswordColumn.height) / 2

        background: Rectangle {  color: window.color; }
        
        width: window.width * 4 / 5 // 80 %
        contentHeight: validateseedpasswordColumn.height

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }

        Column {
            id: validateseedpasswordColumn
            spacing: 10
            width: parent.width
            

            Text {
                text: "Enter Password to confirm"
                wrapMode: Label.Wrap
                //font.bold: true
            }

            TextField {
                id: validateseedpassword
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Row {
                Button {

                    text: "OK"

                    // isDefault: true
                    onClicked: {

                        ctxObject.initerr = ""
                        ctxObject.checkpassword(validateseedpassword.text)

                        if (ctxObject.initerr != "") {
                            ToolTip.delay = -1
                            ToolTip.timeout = 10000
                            ToolTip.text = "Invalid Password."

                            ToolTip.visible = true
                        } else {
                            
                            // clean up text fields
                            validateseedpassword.text = ""

                            // if successfull
                            validateseedpasswordpopop.close()
                            
                            seedPopup.open()
                            
                        }
                    }
                }
                Text {
                    text: "    "
                }

                Button {
                    text: "Cancel"
                    onClicked: {
                        validateseedpasswordpopop.close()
                    }
                }
            }
        }
    }
    
    Popup {
        id: seedPopup
        x: (window.width - width) / 2
        y: (window.height - height) / 2
        width: window.width * 3 / 4
        height: seedColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true
        
        background: Rectangle {  color: window.color; }

        onAboutToShow: {
           // seed_language.currentIndex = 9
          //  seed_language.currentIndex = 0
            ctxObject.seed_language(seed_language.textAt(0))
        }
        /*onClosed: {
            seedlabel.text = ""
        } */// try to clean seed from RAM

        closePolicy: Popup.NoAutoClose
        contentItem: Column {
            id: seedColumn
            width: seedPopup.width

            spacing: 20

            Label {
                width: parent.width
                wrapMode: Label.Wrap
                text: "Wallet SEED (Please keep this seed safe and secure. This can be used to restore your wallet.If seed is lost, you have LOST you wallet !!)"
                font.bold: true
                color: "red"
            }

            Label {
                text: "Seed Language:"
            }

            ComboBox {
                id: seed_language

                property bool sizeToContents
                property int modelWidth
                //width: parent.width * 2/3
                sizeToContents: true

                width: (sizeToContents) ? modelWidth + 2 * leftPadding + 2
                                          * rightPadding + 40 : implicitWidth

                delegate: ItemDelegate {
                    width: seed_language.width
                    text: seed_language.textRole ? (Array.isArray(
                                                        seed_language.model) ? modelData[seed_language.textRole] : model[seed_language.textRole]) : modelData
                    font.weight: seed_language.currentIndex === index ? Font.DemiBold : Font.Normal
                    font.family: seed_language.font.family
                    font.pointSize: seed_language.font.pointSize
                    highlighted: seed_language.highlightedIndex === index
                    hoverEnabled: seed_language.hoverEnabled
                }

                TextMetrics {
                    id: textMetrics
                }

                onModelChanged: {
                    textMetrics.font = seed_language.font
                    for (var i = 0; i < model.length; i++) {
                        textMetrics.text = model[i]
                        modelWidth = Math.max(textMetrics.width, modelWidth)
                    }
                }

                model: ["English", "日本語", "简体中文 (中国)", "Nederlands", "Esperanto", "русский язык", "Español", "Português", "Français", "Deutsch", "Italiano"]
                Component.onCompleted: {
                    currentIndex = 0
                }
                onActivated: {
                    ctxObject.seed_language(seed_language.textAt(currentIndex))
                }
            }

            TextField {
                id: seedlabel
                width: parent.width //seedPopup.width
                wrapMode: TextField.Wrap
                selectByMouse: true
                readOnly: true
                text: ctxObject.seed
            }

            RowLayout {
                width: parent.width

                Button {
                    text: "Ok"
                    onClicked: {
                        //seedlabel.text = ""
                        seedPopup.close()
                    }

                    Material.foreground: Material.primary
                    //  Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }

    Popup {
        id: settingsPopup
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        height: settingsColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true
        background: Rectangle {  color: window.color; }

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            Label {
                text: "Settings"
                font.bold: true
            }

            Switch {
                id: settings_online_remote
                text: "Wallet Online (Remote)"
                checked: true
                onClicked: {
                    if (settings_online_remote.checked == true) {
                        ctxObject.remote_server = remote_server.textAt(
                                    remote_server.currentIndex)

                        ToolTip.delay = -1
                        ToolTip.timeout = 2000
                        ToolTip.text = "Will use remote  server " + remote_server.textAt(
                                    remote_server.currentIndex)

                        ToolTip.visible = true

                        setwalletmode()
                    } else {
                        setwalletmode()
                    }

                    console.log(remote_server.textAt(
                                    remote_server.currentIndex))
                }
            }
            Switch {
                id: settings_online_local
                text: "Wallet Online (local 127.0.0.1:20206)"
                checked: false

                onClicked: {
                    if (settings_online_remote.checked == false
                            && settings_online_local.checked == true) {
                        ctxObject.remote_server = "127.0.0.1:20206"

                        ToolTip.delay = -1
                        ToolTip.timeout = 2000
                        ToolTip.text = "Will use local server"

                        ToolTip.visible = true

                        setwalletmode()
                    } else {
                        setwalletmode()
                    }
                }
            }

            RowLayout {
                spacing: 10

                Label {
                    text: "Remote server:"
                }

                ComboBox {
                    id: remote_server
                    model: [ /*"http://localhost:20206/",*/ "https://rwallet.dero.io", "https://rwallet.dero.live", "https://rwallet1.dero.io","https://rwallet1.dero.live"]
                    Component.onCompleted: {
                        currentIndex = 0
                    }
                    onActivated: {
                        if (settings_online_remote.checked == true) {
                            ctxObject.remote_server = remote_server.textAt(
                                        currentIndex)

                            ToolTip.delay = -1
                            ToolTip.timeout = 2000
                            ToolTip.text = "Will use remote  server " + remote_server.textAt(
                                        currentIndex)

                            ToolTip.visible = true

                            setwalletmode()
                        }

                        console.log(remote_server.textAt(currentIndex))
                    }
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
                    onClicked: {
                        settingsPopup.close()
                    }

                    Material.foreground: Material.primary
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
                /*

                Button {
                    id: cancelButton
                    text: "Cancel"
                    onClicked: {

                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }*/
            }
        }
    }
    
    

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        //y: (window.height - aboutColumn.height) / 2
        width: Math.min(window.width, window.height) / 10 * 9
        contentHeight: aboutColumn.height

        background: Rectangle {  color: window.color; }
             
             
             
        Column {
            id: aboutColumn
            spacing: 5
            
            
            Button {
                    text: "OK"
                    onClicked: {
                        aboutDialog.close()
                    }
            }

            Label {
                text: "About DERO GUI Wallet"
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: 'DERO is decentralized DAG(Directed Acyclic Graph) based blockchain with enhanced reliability, privacy, security, and usability.DERO is industry leading and the first blockchain to have bulletproofs, TLS encrypted Network. <br/>DERO blockchain has the following salient features:' + 
                " <ul>" +
                "<li>DAG Based: No orphan blocks, No soft-forks.</li>"+
                "<li>Extremely fast transactions with 2 minutes confirmation time.</li>"+
                "<li>12 Second Block time.</li>"+
                "<li>SSL/TLS P2P Network.</li>"+
                "<li>CryptoNote: Fully Encrypted Blockchain</li>"+
                "<li>BulletProofs: Zero Knowledge range-proofs(NIZK).</li>"+
                "<li>Ring signatures.</li>"+
                "<li>Fully Auditable Supply.</li>"+
                "<li>DERO blockchain is written from scratch in Golang.</li>"+
                "<li>Developed and maintained by original developers.</li>"+
                "</ul>"+
                '<br/>Please visit <a href="https://www.dero.io">DERO website</a> for more information (support).'
                wrapMode: Label.Wrap
                font.pixelSize: 12
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }

            Label {
                width: aboutDialog.availableWidth
                text: "This program is pre-alpha and is being used/deployed to evaluate QT framework (5.11) and therecipe GO QT bindings for its suitablity for particular purpose. <br/>V" + ctxObject.version
                wrapMode: Label.Wrap
                font.pixelSize: 12
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
        }
        
    }
}
