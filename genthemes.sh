#!/bin/bash

cd out/linux_64/onlyoffice/documentserver/server/FileConverter
LD_LIBRARY_PATH=$PWD/bin \
NODE_ENV=development-linux \
NODE_CONFIG_DIR=$PWD/../Common/config \
./converter
