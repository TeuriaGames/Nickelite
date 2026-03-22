#!/usr/bin/env bash

set -e 

pushd . > /dev/null

VERSION=$(<"../Version.txt")

rm -rf "../_Publish/net10.0-android36.1"

bash Publish-Any.sh net10.0-android36.1 Nickel

mkdir -p "../_Publish/net10.0-android36.1/Nickel/ModLibrary"

cd "../_Publish/net10.0-android36.1"

zip -r "../Nickel-${VERSION}-Android.zip" "Nickel"

popd > /dev/null