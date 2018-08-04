// Copyright 2017-2018 DERO Project. All rights reserved.
// Use of this source code in any form is governed by RESEARCH license.
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

// use this command to create logo ico for windows
// convert images/dero-front-logo.png -define icon:auto-resize=16,48,64,128,256 -compress zip logo.ico
// use mingw windres i686-w64-mingw32-windres icon.rc -o icon_windows_386.syso
// use mingw windres x86_64-w64-mingw32-windres icon.rc -o icon_windows_amd64.syso

package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"sync"

	"github.com/therecipe/qt/core"
	"github.com/therecipe/qt/gui"
	"github.com/therecipe/qt/qml"
	"github.com/therecipe/qt/quickcontrols2"
)
import "github.com/docopt/docopt-go"

import "github.com/deroproject/derosuite/config"
import "github.com/deroproject/derosuite/globals"
import "github.com/deroproject/derosuite/walletapi"

var command_line string = `dero-wallet-gui
DERO Wallet gui: A secure, private blockchain with smart-contracts

Usage:
  dero-wallet-gui [--help] [--version] [--debug] [--testnet]  [--noopengl] [--vmmode]
  dero-wallet-gui -h | --help
  dero-wallet-gui --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --debug       Debug mode enabled, print log messages
  --testnet     Enable testnet mode
  --noopengl    Enable minimal UI using software rendering
  --vmmode      Enable minimal UI using software rendering`

type CtxObject struct {
	core.QObject

	walletptr *walletapi.Wallet

	_ string `property:"version"`

	_ func() `constructor:"init"`

	remote_server string `property:"remote_server"` // remote server
	_             bool   `property:"wallet_online"` // remote server

	_ func(string) `signal:"setwalletonline,auto"`  // used to set wallet online
	_ func()       `signal:"setwalletoffline,auto"` // used to set wallet offline

	_ bool   `property:"wallet_valid"`   // is wallet valid and has been successfully opened
	_ string `property:"wallet_address"` // wallet address
	_ string `property:"someString"`

	_ string `property:"initerr"` // used to track error when initially opening or creating database

	_ func(string)         `signal:"checkpassword,auto"` // used to check password
	_ func(string, string) `signal:"setpassword,auto"`   // used to set new password

	// property related to to outgoing tx
	_ string `property:"tx_hex"`   // wallet address
	_ string `property:"txid_hex"` // wallet address
	_ string `property:"tx_total"`
	_ string `property:"tx_transfer_amount"`
	_ string `property:"tx_change"`
	_ string `property:"tx_fees"`
	_ string `property:"tx_relayed"`

	_ func(string, string, string) `signal:"build_tx,auto"` // used to build up tx
	_ func(string)                 `signal:"relay_tx,auto"` // used to relay tx

	_ string       `property:"seed"`             // seed in localised language
	_ func(string) `signal:"seed_language,auto"` // used to request seed in language

	_ func(string, string)         `signal:"openwallet,auto"`            // used to openwallet
	_ func(string, string)         `signal:"createnewwallet,auto"`       // used to openwallet
	_ func(string, string, string) `signal:"recoverusingseedwords,auto"` // used to recover using seed words
	_ func(string, string, string) `signal:"recoverusingkey,auto"`       // used to recoverkey
	_ func()                       `signal:"closewallet,auto"`           // used to closewallet

	height       int64  `property:"height"`         // wallet height
	topoheight   int64  `property:"topoheight"`     // wallet topoheight
	nwheight     int64  `property:"nwheight"`       // network height
	nwtopoheight int64  `property:"nwtopoheight"`   // network topoheight
	_            string `property:"height_str"`     // height localised string
	_            string `property:"topoheight_str"` // topoheight localised string

	_ string `property:"total_balance"`    // wallet total balance
	_ string `property:"unlocked_balance"` // wallet unlocked balance
	_ string `property:"locked_balance"`   // network locked balance

	_ func()       `signal:"clicked,auto"`
	_ func(string) `signal:"sendString,auto"`

	_ func(string) `signal:"addressVerify,auto"`  // used to verify address
	_ bool         `property:"addressverified"`   // is address verfied
	_ bool         `property:"addressintegrated"` // is address integrated
	_ string       `property:"addressipaymentid"` // integrated payment ID in  hex form

	_ func(string) `signal:"paymentidVerify,auto"` // used to verify payment id
	_ bool         `property:"paymentidverified"`  // is payment id  verfied

	_ func(string) `signal:"amountVerify,auto"` // used to verify amount
	_ bool         `property:"amountverified"`  // is amount  verified

	_ func() `signal:"genintegratedaddress,auto"`         // used to verify amount
	_ string `property:"integrated_32_address"`           // integrated i32 address
	_ string `property:"integrated_32_address_paymentid"` // integrated i32 address
	_ string `property:"integrated_8_address"`            // integrated i8 address
	_ string `property:"integrated_8_address_paymentid"`  // integrated i32 address

	_ func(bool, bool, bool, int64) `signal:"reloadhistory,auto"` // used to reload history, available,in,out

	_ []string `property:"historyListHeight"`
	_ []string `property:"historyListTopoHeight"`
	_ []string `property:"historyListTXID"`
	_ []string `property:"historyListAmount"`
	_ []string `property:"historyListPaymentID"`
	_ []string `property:"historyListStatus"`
	_ []string `property:"historyListUnlockTime"`
	_ []string `property:"historyListOutDetails"` // contains json string

	sync.Mutex
}

var count int

func (t *CtxObject) init() {
	global_object = t // capture reference to original object

	/*
	    var err error
	   global_object.walletptr ,err  = walletapi.Open_Encrypted_Wallet("/tmp/tmp2.db", "")
	   if err != nil {
	           fmt.Printf("Wallet opened successfully")
	   }

	   addr := global_object.walletptr.GetAddress()
	   global_object.SetWallet_address(addr.String())

	   global_object.SetWallet_valid(true)  // mark wallet as valid
	*/

	global_object.SetWallet_valid(false)

	t.SetVersion(Version.String())

	t.SetSomeString(fmt.Sprintf("%d times", count))

}

func (t *CtxObject) clicked() {
	t.SetSomeString(fmt.Sprintf("%d times", count))
	count++
	fmt.Printf("clicked qml button\n")
}

func (t *CtxObject) sendString(a string) {
	fmt.Println("sendString:", a)
}

var global_object *CtxObject
var global_gui *gui.QGuiApplication

func main() {

	var err error
	globals.Arguments, err = docopt.Parse(command_line, nil, true, "DERO atlantis wallet : work in progress", false)
	//globals.Arguments, err = docopt.ParseArgs(command_line, os.Args[1:],  "DERO daemon : work in progress")
	if err != nil {
		log.Fatalf("Error while parsing options err: %s\n", err)
	}

	globals.Init_rlog()
	// parse arguments and setup testnet mainnet
	globals.Initialize() // setup network and proxy
	//globals.Logger.Infof("") // a dummy write is required to fully activate logrus

	// all screen output must go through the readline
	//globals.Logger.Out = l.Stdout()

	if globals.Arguments["--noopengl"].(bool) == true || globals.Arguments["--vmmode"].(bool) == true { // setup software rendering if requested
		os.Setenv("QT_QUICK_BACKEND", "software")
	}

	//QT_QUICK_BACKEND=software

	globals.Logger.Infof("Arguments %+v", globals.Arguments)
	globals.Logger.Infof("DERO GUI Wallet : %s  This version is under heavy development, use it for testing/evaluations purpose only", Version.String())
	globals.Logger.Infof("DERO Wallet API : %s  This version is under heavy development, use it for testing/evaluations purpose only", config.Version.String())
	globals.Logger.Infof("Copyright 2017-2018 DERO Project. All rights reserved.")
	globals.Logger.Infof("OS:%s ARCH:%s GOMAXPROCS:%d", runtime.GOOS, runtime.GOARCH, runtime.GOMAXPROCS(0))
	globals.Logger.Infof("Wallet in %s mode", globals.Config.Name)

	core.QCoreApplication_SetApplicationName("DERO-WALLET-GUI")
	core.QCoreApplication_SetOrganizationName("DERO PROJECT")
	core.QCoreApplication_SetAttribute(core.Qt__AA_EnableHighDpiScaling, true)

	guiptr := gui.NewQGuiApplication(len(os.Args), os.Args)

	_ = guiptr
	//guiptr.SetWindowIcon(gui.NewQIcon5("copy.svg"))
	// guiptr.SetWindowIcon(gui.NewQIcon5(":/images/copy.svg"))
	guiptr.SetWindowIcon(gui.NewQIcon5(":/images/dero-front-logo.png"))
	/*var (
		settings = core.NewQSettings5(nil)
		style    = quickcontrols2.QQuickStyle_Name()
	)
	if style != "" {
		settings.SetValue("style", core.NewQVariant14(style))
	} else {
		quickcontrols2.QQuickStyle_SetStyle(settings.Value("style", core.NewQVariant14("")).ToString())
	}*/

	go update_heights_balances() // handle wallet in another goroutine

	// use the material style
	// the other inbuild styles are:
	// Default, Fusion, Imagine, Universal
	quickcontrols2.QQuickStyle_SetStyle("Material")

	var engine = qml.NewQQmlApplicationEngine(nil)
	engine.RootContext().SetContextProperty("ctxObject", NewCtxObject(nil))
	engine.Load(core.NewQUrl3("qrc:/main.qml", 0))

	gui.QGuiApplication_Exec()
}
