#!/bin/bash -ex

# 25.08.2022 Merge pull request #2000 from ldorau/common-1.0.0-release
LIBRPMA_VERSION=1.0.0
ZIP_FILE=rpma.zip

WORKDIR=$(pwd)

# install librpma
wget -O $ZIP_FILE https://github.com/pmem/rpma/archive/${LIBRPMA_VERSION}.zip
unzip $ZIP_FILE
mkdir -p rpma-${LIBRPMA_VERSION}/build
cd rpma-${LIBRPMA_VERSION}/build
cmake .. -DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_DOC=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TESTS=OFF
make -j$(nproc)
sudo make -j$(nproc) install
cd $WORKDIR
rm -rf $ZIP_FILE rpma-${LIBRPMA_VERSION}
