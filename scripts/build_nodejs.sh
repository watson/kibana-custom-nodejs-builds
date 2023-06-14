#!/bin/bash
set -euo pipefail

source ./scripts/common.sh

# TARGET_VERSION provided in env
# ARCH provided in env
assert_correct_arch $ARCH

TARGET_NODE_VERSION="v$TARGET_VERSION"
BUILD_IMAGE_NAME="docker.elastic.co/elastic/nodejs-custom:$TARGET_VERSION-$ARCH"
TARGET_PLATFORM="linux/$ARCH"
RELEASE_URL_BASE="https://unofficial-builds.nodejs.org/download/release/"


echo '--- Downloading node source'
curl --create-dirs --output-dir ./workdir/src -fsSLO --compressed \
  https://nodejs.org/download/release/$TARGET_NODE_VERSION/node-$TARGET_NODE_VERSION.tar.xz
tar -xf ./workdir/src/node-$TARGET_NODE_VERSION.tar.xz -C ./workdir/src
chmod -R a+rwx ./workdir/


echo "--- Buidling node for $TARGET_PLATFORM"
docker run --rm -it --platform $TARGET_PLATFORM \
  -v ./workdir:/home/node/workdir:Z \
  $BUILD_IMAGE_NAME \
  $RELEASE_URL_BASE \
  $TARGET_NODE_VERSION
