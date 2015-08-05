#!/usr/bin/env bash
xcodebuild -archivePath kawa -scheme kawa archive

rm -rf Kawa.app
xcodebuild -exportArchive -exportFormat APP -archivePath kawa.xcarchive -exportPath Kawa
