#!/usr/bin/env bash

if [[ -z "$INSTALLDIR" ]]; then
    INSTALLDIR="$HOME/Documents/Arduino"
fi
echo "INSTALLDIR: $INSTALLDIR"

pde_path=`find ./ -name pde.jar`
core_path=`find ./ -name arduino-core.jar`
lib_path=`find ./ -name commons-codec-1.7.jar`
if [[ -z "$core_path" || -z "$pde_path" ]]; then
    echo "Some java libraries have not been built yet (did you run ant build?)"
    return 1
fi
echo "pde_path: $pde_path"
echo "core_path: $core_path"
echo "lib_path: $lib_path"

set -e

mkdir -p bin
javac -cp "$pde_path:$core_path:$lib_path" src/ESP8266FSMake.java -d bin 

pushd bin
mkdir -p $INSTALLDIR/tools
rm -rf $INSTALLDIR/tools/ESP8266FSMake
mkdir -p $INSTALLDIR/tools/ESP8266FSMake/tool
jar cvfe $INSTALLDIR/tools/ESP8266FSMake/tool/esp8266fs.jar com.esp8266.mkspiffsmake.ESP8266FSMake *
popd

dist=$PWD/dist
rev=1.0
mkdir -p $dist
pushd $INSTALLDIR/tools
zip -r $dist/ESP8266FSMake-$rev.zip ESP8266FSMake/
popd
