#!/bin/sh

# This scripts builds the dynamic linked qt version using docker and then packs using appimage
qtdeploy -docker build linux
# qtdeploy -docker build windows_64_static

cp -f ./deploy/linux/dero-wallet-gui ./dero-wallet-gui.appdir
cp -rf ./deploy/linux/lib ./dero-wallet-gui.appdir/
cp -rf ./deploy/linux/plugins ./dero-wallet-gui.appdir/
cp -rf ./deploy/linux/qml ./dero-wallet-gui.appdir/

#clean up debug files
find ./dero-wallet-gui.appdir/ -name "*.so.debug" -type f -delete



ARCH=x86_64 ~/Downloads/appimagetool-x86_64.AppImage dero-wallet-gui.appdir/ dero-wallet-gui-linux-x86_64.appimage
