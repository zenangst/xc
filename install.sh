#!/bin/sh
swift build --disable-sandbox
rm /usr/local/bin/xc
cp .build/debug/xc /usr/local/bin/xc
