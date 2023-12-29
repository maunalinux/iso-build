#!/bin/bash

################################################################################
# Title:        Bldhelper.sh
# Description:  Script to build Mauna linux ISO image
# Author:       manuel rosa <manuelsilvarosa@gmail.com>
# Date:         Outubro 29, 2023
# License:      GPL-3.0-or-later
################################################################################

# Set environment variables
PREFIX=MaunaLinux-24-mate
SUFFIX=amd64
BUILD=mate
TODAY=$(date -u +"%Y-%m-%d")
FileName="${PREFIX}-${SUFFIX}"
LOCATION="/home/$SUDO_USER/out/${BUILD}"
LogDir="/home/$SUDO_USER/logs"
WorkingDir="/home/$SUDO_USER/iso-build/mate"

# Execute the ISO building script
cd ${WorkingDir}
./build-mate.sh 2>&1 | tee /tmp/build_log.txt

# Move and rename the ISO file
cd build
mv *.iso ${FileName}.iso

# Create the checksum file for the ISO
sha512sum ${FileName}.iso > ${FileName}-sha512.checksum

# Remove old ISO and checksum files from the desired location
rm -f ${LOCATION}/${FileName}*.iso
rm -f ${LOCATION}/${FileName}*-sha512.checksum

# Move the ISO and checksum files to the desired location
mkdir -p ${LOCATION}
mv ${FileName}.iso ${LOCATION}
mv ${FileName}-sha512.checksum ${LOCATION}

# Move the log file to the log directory (if it exists)
mkdir -p ${LogDir}
if [ -f /tmp/build_log.txt ]; then
    LogFileName="${PREFIX}-${SUFFIX}-${BUILD}.log"
    mv /tmp/build_log.txt ${LogDir}/${LogFileName}
fi
# Clean the build folder 
lb clean

# Remove the "build" directory and its contents
cd ..
rm -rf build

