// Copyright 2017-2018 DERO Project. All rights reserved.
// Use of this source code in any form is governed by GPL 3 license.
// license can be found in the LICENSE file.
// GPG: 0F39 E425 8C65 3947 702A  8234 08B2 0360 A03A 9DE8
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
import QtQuick.Controls 2.0

Page {
    id: page

    Popup {
        id: validatetemporarypasswordpopop
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - validatetemporarypasswordColumn.height) / 2

        background: Rectangle {
            color: window.color
        }

        width: swipeView.width * 4 / 5 // 80 %
        contentHeight: validatetemporarypasswordColumn.height

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
            }
        }

        Column {
            id: validatetemporarypasswordColumn
            spacing: 10
            width: parent.width
            Text {
                width: parent.width
                text: "Destination : " + "<b>" + daddr.text + "</b>"
                wrapMode: Text.Wrap
            }
            Text {
                text: "Transferring : " + "<b>" + ctxObject.tx_transfer_amount + " DERO" + "</b>"
                wrapMode: Text.Wrap
            }

            Text {
                width: parent.width
                text: "TXID : " + "<b>" + ctxObject.txid_hex + "</b>"
                wrapMode: Text.Wrap
            }

            Text {
                text: "Total Amount Selected : " + "<b>" + ctxObject.tx_total + " DERO" + "</b>"
                wrapMode: Text.Wrap
            }

            Text {
                text: "Change (will come back) : " + "<b>" + ctxObject.tx_change + " DERO" + "</b>"
                wrapMode: Text.Wrap
            }

            Text {
                text: "Fees : " + "<b>" + ctxObject.tx_fees + " DERO" + "</b>"
                wrapMode: Text.Wrap
            }

            Text {
                text: "Enter Password to confirm"
                wrapMode: Label.Wrap
                //font.bold: true
            }

            TextField {
                id: validatetemporarypassword
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password //TextInput.PasswordEchoOnEdit
            }

            Row {
                Button {

                    text: "Send Transaction"

                    // isDefault: true
                    onClicked: {

                        ctxObject.initerr = ""
                        ctxObject.checkpassword(validatetemporarypassword.text)

                        if (ctxObject.initerr != "") {
                            ToolTip.delay = -1
                            ToolTip.timeout = 10000
                            ToolTip.text = "Invalid Password."

                            ToolTip.visible = true
                        } else {
                            // if successfull
                            validatetemporarypasswordpopop.close()

                            // clean up text fields
                            validatetemporarypassword.text = ""

                            // sending transsaction
                            ctxObject.initerr = ""
                            ctxObject.relay_tx(ctxObject.tx_hex)

                            if (ctxObject.initerr == "") {

                                ToolTip.delay = -1
                                ToolTip.timeout = 10000
                                ToolTip.text = "Transaction " + ctxObject.txid_hex
                                        + " relayed successfully"

                                ToolTip.visible = true
                            } else {
                                ToolTip.delay = -1
                                ToolTip.timeout = 10000
                                ToolTip.text = ctxObject.initerr

                                ToolTip.visible = true
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
                        validatetemporarypasswordpopop.close()
                    }
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        //        anchors.top: parent.top
        //anchors.left : parent.left
        //anchors.right: parent.right
        //anchors.bottom: anchors.bottom - 80 //TabBar.top
        currentIndex: tabBar.currentIndex

        onCurrentIndexChanged: {
            // tabBar.currentIndex = currentIndex
            switch (currentIndex) {
            case 0:
                titleLabel.text = qsTr("Send DERO")
                break
            case 1:
                titleLabel.text = qsTr("Receive DERO")
                break
            case 2:
                titleLabel.text = qsTr("Transaction History")
                break
            case 3:
                titleLabel.text = qsTr("About DERO project")
                break
            case 4:
                titleLabel.text = qsTr("Assets & Smart Contracts")
                break
            }
        }

        // enable vertical scrolling in send pane
        Flickable {
            id: listView
            contentWidth: width
            contentHeight: panesend.implicitHeight

            ScrollBar.vertical: ScrollBar {
            }

            Pane {
                id: panesend
                width: swipeView.width
                height: swipeView.height
                property string title: "First"

                Column {
                    //spacing: 10
                    width: parent.width

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        text: "SEND DERO to another user"
                    }

                    Rectangle {
                        height: 20
                        color: "transparent"
                        width: parent.width
                    }

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        // horizontalAlignment: Qt.AlignHCenter
                        text: "Destination Address"
                    }

                    TextField {
                        id: daddr
                        placeholderText: qsTr("Destination address")
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true

                        onTextChanged: {
                            ctxObject.addressVerify(daddr.text)

                            if (ctxObject.addressverified === true) {
                                // make it GREEN
                                console.log("green")
                                daddr.color = "green"
                            } else {
                                // make it RED
                                console.log("red")
                                daddr.color = "red"
                            }

                            if ((ctxObject.addressverified === true)
                                    && (ctxObject.addressintegrated === true)) {
                                // make it GREEN
                                console.log("integrated")
                                sendpaymentid.text = ctxObject.addressipaymentid
                                sendpaymentid.readOnly = true
                            } else {
                                // make it RED
                                console.log("non-integrated")
                                sendpaymentid.text = ""
                                sendpaymentid.readOnly = false
                            }

                            // console.log("address textfield + " + daddr.text)
                        }
                    }

                    Rectangle {
                        height: 20
                        color: "transparent"
                        width: parent.width
                    }

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        //horizontalAlignment: Qt.AlignHCenter
                        text: "Amount (in DERO)"
                    }

                    TextField {
                        id: damount
                        placeholderText: qsTr("0.0")
                        selectByMouse: true

                        onTextChanged: {
                            ctxObject.amountVerify(text)
                            if (ctxObject.amountverified === true) {
                                // make it GREEN
                                color = "green"
                            } else {
                                // make it RED
                                color = "red"
                            }
                        }
                    }

                    Rectangle {
                        height: 20
                        color: "transparent"
                        width: parent.width
                    }

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        // horizontalAlignment: Qt.AlignHCenter
                        text: "Payment ID (16 or 64 hex characters) Optional"
                    }

                    TextField {
                        id: sendpaymentid
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        placeholderText: qsTr("16 or 64 hex characters")

                        onTextChanged: {
                            ctxObject.paymentidVerify(sendpaymentid.text)

                            if (ctxObject.paymentidverified === true) {
                                // make it GREEN
                                console.log("green")
                                sendpaymentid.color = "green"
                            } else {
                                // make it RED
                                console.log("red")
                                sendpaymentid.color = "red"
                            }
                        }
                    }

                    Rectangle {
                        //height: 5
                        id: tmprectangle
                        color: "transparent"
                        width: parent.width
                        anchors.top: sendpaymentid.bottom

                        Button {

                            text: "Send NOW"
                            anchors.horizontalCenter: parent.horizontalCenter
                            // isDefault: true
                            onClicked: {

                                // build up a transaction so as it could be confirmed
                                ctxObject.initerr = ""
                                ctxObject.build_tx(daddr.text, damount.text,
                                                   sendpaymentid.text)

                                // if an error occured, display error
                                if (ctxObject.initerr != "") {
                                    ToolTip.delay = -1
                                    ToolTip.timeout = 10000
                                    ToolTip.text = ctxObject.initerr

                                    ToolTip.visible = true
                                } else {
                                    // if successfull, confirm password before relaying
                                    validatetemporarypasswordpopop.open()
                                }

                                console.log("Send NOW button clicked ")
                            }
                        }

                        Button {

                            text: "Donate"
                            anchors.right: parent.right
                            // isDefault: true
                            // anchors.horizontalCenter: Qt.AlignRight
                            onClicked: {

                                daddr.text = "dERoNgyutMJ1sEJEPY4WELLAVk1ov4euQQvXfWW7z4JgWCN77A8gy5pHp6fBAZasLUMhs4B7idoWMGzG1Dd6iho32972N6MzNZ"

                                ToolTip.delay = -1
                                ToolTip.timeout = 4000
                                ToolTip.text = "Thank you for donation to DERO foundation"
                                ToolTip.visible = true

                                //console.log("Donate button clicked ")
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        anchors.top: tmprectangle.bottom
                    }

                    Rectangle {
                        height: 70
                        color: "transparent"
                        width: parent.width
                    }

                    /*

TextField
{
    id: textInput
    width: parent.width
    placeholderText: qsTr("Filter")
    selectByMouse: true


    property int selectStart
property int selectEnd
property int curPos

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        hoverEnabled: true
        onClicked: {
            textInput.selectStart = textInput.selectionStart;
            textInput.selectEnd = textInput.selectionEnd;
            textInput.curPos = textInput.cursorPosition;
            contextMenu.x = mouse.x;
            contextMenu.y = mouse.y;
            contextMenu.open();
            textInput.cursorPosition = textInput.curPos;
            textInput.select(textInput.selectStart,textInput.selectEnd);
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                textInput.selectStart = textInput.selectionStart;
                textInput.selectEnd = textInput.selectionEnd;
                textInput.curPos = textInput.cursorPosition;
                contextMenu.x = mouse.x;
                contextMenu.y = mouse.y;
                contextMenu.open();
                textInput.cursorPosition = textInput.curPos;
                textInput.select(textInput.selectStart,textInput.selectEnd);
            }
        }

        Menu {
            id: contextMenu
            MenuItem {
                text: "Cut"
                onTriggered: {
                    textInput.cut()
                }
            }
            MenuItem {
                text: "Copy"
                onTriggered: {
                    textInput.copy()
                }
            }
            MenuItem {
                text: "Paste"
                onTriggered: {
                    textInput.paste()
                }
            }
        }
    }
}

                    Image {
                        source: "qrc:/images/arrows.png"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    */
                }
            }
        }

        // enable vertical scrolling in send pane
        Flickable {
            contentWidth: width
            contentHeight: panereceive.implicitHeight

            ScrollBar.vertical: ScrollBar {
            }

            Pane {
                id: panereceive
                width: swipeView.width
                height: swipeView.height

                Column {
                    width: parent.width

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        text: "Receive DERO from another user"
                    }

                    Row {
                        Label {
                            //width: parent.width
                            //wrapMode: Label.Wrap
                            //horizontalAlignment: Qt.AlignHCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Your Address : " // + ctxObject.wallet_address
                            font.bold: true
                        }

                        Button {
                            anchors.verticalCenter: parent.verticalCenter
                            // horizontalAlignment: Qt.AlignHCenter
                            text: "copy"

                            /*  icon.color: "transparent" // not available in 5.8
                              icon.source: "qrc:/images/copy.svg"
                          */
                            onClicked: {
                                receive_addr.selectAll() // select everything
                                receive_addr.copy() // copy to clipboard
                                receive_addr.deselect() // deselect everything
                                console.log("Copy address clicked ")
                            }
                        }
                    }

                    TextField {
                        id: receive_addr
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        readOnly: true
                        text: ctxObject.wallet_address
                    }

                    Button {

                        text: "Generate Address with Payment ID (Integrated Address)"
                        anchors.horizontalCenter: parent.horizontalCenter
                        // isDefault: true
                        onClicked: {
                            ctxObject.genintegratedaddress()
                        }
                    }

                    Row {
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Integrated Address Random32 : "
                            font.bold: true
                        }

                        Button {
                            anchors.verticalCenter: parent.verticalCenter
                            // horizontalAlignment: Qt.AlignHCenter
                            text: "copy"
                            /*  icon.color: "transparent" // not available in 5.8
                              icon.source: "qrc:/images/copy.svg"
                          */
                            // isDefault: true
                            onClicked: {
                                //ctxObject.genintegratedaddress()
                                receive_addr_32.selectAll() // select everything
                                receive_addr_32.copy() // copy to clipboard
                                receive_addr_32.deselect(
                                            ) // deselect everything
                                console.log("Copy  integrated address clicked ")
                            }
                        }
                    }

                    TextField {
                        id: receive_addr_32
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        readOnly: true
                        text: ctxObject.integrated_32_address
                    }

                    Row {
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Integrated 32 byte payment id: "
                            font.bold: true
                        }

                        Button {
                            anchors.verticalCenter: parent.verticalCenter
                            // horizontalAlignment: Qt.AlignHCenter
                            text: "copy"
                            /*  icon.color: "transparent" // not available in 5.8
                              icon.source: "qrc:/images/copy.svg"
                          */
                            // isDefault: true
                            onClicked: {
                                //ctxObject.genintegratedaddress()
                                receive_addr_32_payment_id.selectAll(
                                            ) // select everything
                                receive_addr_32_payment_id.copy(
                                            ) // copy to clipboard
                                receive_addr_32_payment_id.deselect(
                                            ) // deselect everything
                                console.log("Copy 32 byte payment ID clicked ")
                            }
                        }
                    }
                    TextField {
                        id: receive_addr_32_payment_id
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        readOnly: true
                        text: ctxObject.integrated_32_address_paymentid
                    }

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        // horizontalAlignment: Qt.AlignHCenter
                        text: "Integrated Address Random8 : "
                        font.bold: true
                        visible: false
                    }

                    TextField {
                        id: receive_addr_8
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        readOnly: true
                        visible: false
                        text: ctxObject.integrated_8_address
                    }

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        // horizontalAlignment: Qt.AlignHCenter
                        text: "Integrated 8 byte payment id (Encrypted) : "
                        font.bold: true
                        visible: false
                    }

                    TextField {
                        id: receive_addr_8_payment_id
                        width: parent.width
                        wrapMode: TextField.Wrap
                        selectByMouse: true
                        readOnly: true
                        visible: false
                        text: ctxObject.integrated_8_address_paymentid
                    }
                }
            }
        }

        // enable vertical scrolling in send pane
        Flickable {
            contentWidth: width
            contentHeight: panehistory.implicitHeight

            ScrollBar.vertical: ScrollBar {
            }

            // shows history pane
            Pane {
                id: panehistory
                width: swipeView.width
                height: swipeView.height

                Column {
                    width: parent.width
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        Switch {
                            id: incoming
                            text: "Show Incoming"
                            checked: true
                        }
                        Switch {
                            id: outgoing
                            text: "Show Outgoing"
                            checked: true
                        }
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        Label {
                            text: "Show last"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        SpinBox {
                            anchors.verticalCenter: parent.verticalCenter
                            id: limit
                            value: 50
                            stepSize: 10
                            from: 10
                            to: 5000
                            // width: itemWidth
                            // editable: true
                        }
                    }

                    Button {

                        id: reloadhistorybutton
                        text: "Reload transaction history"
                        anchors.horizontalCenter: parent.horizontalCenter
                        // isDefault: true
                        onClicked: {
                            ctxObject.reloadhistory(false, incoming.checked,
                                                    outgoing.checked,
                                                    limit.value)

                            // at this point all transaction history is setup in properties, now we set it up to list model
                            //transactionlistmodel.clear();
                            console.log("total elements txid ",
                                        ctxObject.historyListTXID.length)
                            console.log("total elements ",
                                        ctxObject.historyListHeight.length)
                            //console.log("details  elements ", ctxObject.historyListOutDetails.length);
                            var i

                            var textdata
                            textdata = ""
                            for (i = 0; i < ctxObject.historyListHeight.length; i++) {

                                var txline
                                var maincolor

                                //console.log("i",i,"'",ctxObject.historyListOutDetails[i],"'");
                                if (ctxObject.historyListStatus[i] == "0") {
                                    maincolor = "green"
                                } else {
                                    maincolor = "red"
                                }

                                txline = (i + 1) + ". " + "<font color='" + maincolor + "'>"
                                        + ctxObject.historyListHeight[i] + "/"
                                        + ctxObject.historyListTopoHeight[i] + " "
                                        + ctxObject.historyListAmount[i] + ' DERO  <a href="https://explorer.dero.io/tx/' + ctxObject.historyListTXID[i] + '">' + ctxObject.historyListTXID[i] + "</a> " + "<font color='#6c3483'>" + ctxObject.historyListPaymentID[i]
                                        + "</font></font> <br/>" // + details

                                /*   mobject = {"counter":i+1, "bheight": ctxObject.historyListHeight[i], "topoheight": ctxObject.historyListTopoHeight[i], "txid":  ctxObject.historyListTXID[i], "amount" : ctxObject.historyListAmount[i],"payid": ctxObject.historyListPaymentID[i], "fcolor": ctxObject.historyListStatus[i] == "0" ? "green": "red", "unlock": ctxObject.historyListUnlockTime  }

                       mobject["details"] = " ";*/

                                // if more details are available process them
                                if (ctxObject.historyListOutDetails[i].length > 50) {
                                    // console.log(" histout" , ctxObject.historyListOutDetails[i]);
                                    var det
                                    try {
                                        det = JSON.parse(
                                                    ctxObject.historyListOutDetails[i])

                                        for (var j = 0; j < det.to.length; j++) {
                                            //mobject["details"] = mobject["details"] + "Address: " + det.to[i] + " Amount: " +   det.amount[i] + "\n";
                                            txline = txline + "<b>Address: </b>" + det.to[j]
                                                    + " <b>Amount: </b>" + det.amount[j] + "<br/>"
                                        }

                                        txline = txline + "<b>Fees : </b>" + det.fees + "<br/>"
                                        txline = txline + "<b>Payment ID : </b>"
                                                + det.paymentid + "<br/>"
                                        txline = txline + "<b>TX secret key : </b>"
                                                + det.tx_secret_key + "<br/>"

                                        // mobject["details"] = mobject["details"] + "Fees : " + det.fees + "\n";
                                        // mobject["details"] = mobject["details"] + "Payment ID : " + det.paymentid + "\n";
                                        // mobject["details"] = mobject["details"] + "TX secret key : " + det.tx_secret_key + "\n";
                                    } catch (e) {
                                        console.log("exception", e.name,
                                                    e.message)
                                    }
                                    //   console.log("det   jsonned ",   det, JSON.stringify(det, null, 4) );
                                }

                                //transactionlistmodel.append(mobject);

                                // console.log(i, "cell height ",  dummytextarea.contentHeight)
                                textdata = textdata + txline
                            }

                            historylog.text = textdata
                        }
                    }

                    TextArea {
                        id: historylog
                        width: swipeView.width //parent.cellWidth
                        wrapMode: TextArea.Wrap
                        selectByMouse: true
                        readOnly: true
                        font.family: "Monospace"
                        textFormat: TextArea.RichText
                        //text: counter+ " " +  bheight +"/" + topoheight + " " + amount + ' DERO  <a href="http://yahoo.com">' + txid + "</a> "+ "<font color='#6c3483'>" + payid +"</font>" + details ;
                        //color:fcolor;
                        //anchors.horizontalCenter: parent.horizontalCenter
                        onLinkActivated: {
                            Qt.openUrlExternally(link)
                            console.log(link + " link activated")
                        }
                    }

                    // used to measure cell height
                    TextArea {
                        id: dummytextarea
                        width: swipeView.width
                        wrapMode: TextArea.Wrap
                        selectByMouse: true
                        visible: false
                        font.family: "Monospace"
                        textFormat: TextArea.RichText
                        text: "108272/111614 7.992500000000 DERO afe4379e7656667aafc223c98a24884624dbc5edb652644d920af2d3d92c5202  afe4379e7656667aafc223c98a24884624dbc5edb652644d920af2d3d92c5202     "
                    }
                }
            }
        }

        // enable vertical scrolling in send pane
        Flickable {
            contentWidth: width
            contentHeight: aboutpane.implicitHeight

            ScrollBar.vertical: ScrollBar {
            }
            Pane {
                id: aboutpane
                width: swipeView.width
                height: swipeView.height

                Column {
                    spacing: 40
                    width: parent.width

                    Label {
                        width: parent.width
                        wrapMode: Label.Wrap
                        horizontalAlignment: Qt.AlignHCenter
                        text: "About DERO project"
                    }

                    Text {
                        width: parent.width
                        wrapMode: Text.Wrap
                        //horizontalAlignment: Qt.AlignHCenter
                        // font.family: "Monospace"

                        //textFormat: Text.RichText
                        text: 'DERO is decentralized DAG(Directed Acyclic Graph) based blockchain with enhanced reliability, privacy, security, and usability.DERO is industry leading and the first blockchain to have bulletproofs, TLS encrypted Network. <br/>DERO blockchain has the following salient features:'
                              + " <ul>" + "<li>DAG Based: No orphan blocks, No soft-forks.</li>"
                              + "<li>Extremely fast transactions with 2 minutes confirmation time.</li>" + "<li>12 Second Block time.</li>" + "<li>SSL/TLS P2P Network.</li>" + "<li>CryptoNote: Fully Encrypted Blockchain</li>" + "<li>BulletProofs: Zero Knowledge range-proofs(NIZK).</li>" + "<li>Ring signatures.</li>" + "<li>Fully Auditable Supply.</li>" + "<li>DERO blockchain is written from scratch in Golang.</li>" + "<li>Developed and maintained by original developers.</li>" + "</ul>" + '<br/>Please visit <a href="https://www.dero.io">DERO website</a> for more information (support).'

                        onLinkActivated: {
                            Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }

        Pane {
            width: swipeView.width
            height: swipeView.height

            Column {
                spacing: 40
                width: parent.width

                Label {
                    width: parent.width
                    wrapMode: Label.Wrap
                    horizontalAlignment: Qt.AlignHCenter
                    text: "ToDo Add more info..."
                }
            }
        }
    }

    footer: Column {

        TabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex
            width: parent.width

            TabButton {
                text: "Send"
                onClicked: {
                    titleLabel.text = "Send DERO"
                    console.log(tabBar.height)
                }
            }
            TabButton {
                text: "Receive"
                // onClicked: {  titleLabel.text = "Receive DERO" }
            }
            TabButton {
                text: "History"
                // onClicked: {  titleLabel.text = "Transaction History" }
            }
            TabButton {
                text: "About"
                // onClicked: {  titleLabel.text = "DERO Balance" }
            }
            TabButton {

                //    text: "Donate"
                text: "Smart Contracts/Assets"
            }
        }

        Rectangle {
            color: "lightgrey"
            width: parent.width
            height: height_tracker.height * 3

            Column {
                width: parent.width
                Label {
                    id: height_tracker
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: ctxObject.height + "/" + ctxObject.nwheight

                    font.bold: true
                    horizontalAlignment: Label.AlignHCenter

                    // may be we can use a global timer
                    /* Timer {

        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            console.log( "timer fired ", ctxObject.height + "/" + ctxObject.nwheight)
            height_tracker.text = ctxObject.height + "/" + ctxObject.nwheight }
    }*/
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Total : " + ctxObject.total_balance + " DERO"

                    font.bold: true
                    horizontalAlignment: Label.AlignHCenter
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Locked : " + ctxObject.locked_balance + " DERO"

                    font.bold: true
                    horizontalAlignment: Label.AlignHCenter
                }
            }
        }
    }
}
