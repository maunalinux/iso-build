#!/bin/bash

################################################################################
# Title:        build-xfce.sh
# Description:  Script to build Mauna linux ISO image
# Author:       manuel rosa <manuelsilvarosa@gmail.com>
# Modified:     Mauna Linux <dev@maunalinux.top>
# Date:         Março 05, 2024
# License:      GPL-3.0-or-later
################################################################################

PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"

# Set the working folder variable
build="$(pwd)"

# Create the build folder, move into it removing stale mountpoints and files there.
[ -e build ] && [ ! -d build ] && rm -f build || [ ! -e build ] && mkdir build
cd build
umount $(mount | grep "${PWD}/chroot" | tac | cut -f3 -d" ") 2>/dev/null
for i in * .build ; do [ $i = cache ] && continue || rm -rf $i ; done

# Set of the structure to be used for the ISO and Live system.
# See /usr/lib/live/build/config for a full list of examples.
# Up above is the manual description of what options I used so far.

lb config noauto \
	--binary-images iso-hybrid \
	--mode debian \
	--architectures amd64 \
	--linux-flavours amd64 \
	--distribution bookworm \
	--archive-areas "main contrib non-free non-free-firmware" \
	--debootstrap-options --include=ca-certificates \
	--debian-installer live \
	--debian-installer-distribution bookworm \
	--updates true \
	--security true \
	--backports false \
	--cache true \
	--uefi-secure-boot enable \
	--firmware-binary false \
	--firmware-chroot false \
	--iso-application "Mauna" \
	--iso-preparer "Mauna-https://maunalinux.top" \
	--iso-publisher "Mauna-https://maunalinux.top" \
	--iso-volume "MaunaLinux" \
	--image-name "MaunaLinux" \
	--win32-loader false \
	--checksums sha512 \
	--zsync false \
	--utc-time true \
     "${@}"

# Install the Xfce Desktop 
#mkdir -p $build/build/config/package-lists
#echo xfce4 xfce4-goodies > $build/build/config/package-lists/desktop.list.chroot 

# Install software
echo "# Install software to the squashfs for calamares to unpack to the OS.
linux-headers-amd64
mauna-xfce-desktop
mauna-info-xfce
calamares
calamares-settings-mauna
gir1.2-soup-2.4

" > $build/build/config/package-lists/packages.list.chroot 

# Packages to be stored in /pool but not installed in the OS .
echo "# These packages are available to the installer, for offline use. 
efibootmgr
grub-common
grub2-common
grub-efi
grub-efi-amd64
grub-efi-amd64-bin
grub-efi-amd64-signed
libefiboot1
libefivar1
mokutil
os-prober
shim-helpers-amd64-signed
shim-signed
shim-signed-common
shim-unsigned

" > $build/build/config/package-lists/installer.list.binary

# Setup the chroot structure
mkdir -p $build/build/config/archives
mkdir -p $build/build/config/includes.binary
mkdir -p $build/build/config/hooks/normal
mkdir -p $build/build/config/hooks/live
mkdir -p $build/build/config/includes.chroot/usr/share/applications
mkdir -p $build/build/config/includes.chroot/etc/live/config.conf.d
mkdir -p $build/build/config/includes.chroot/etc
mkdir -p $build/build/config/includes.chroot/etc/skel/Desktop
mkdir -p $build/build/config/includes.chroot/etc/lightdm
mkdir -p $build/build/config/includes.installer/usr/share

# Copy Configs to the chroot
cp $build/applications/* $build/build/config/includes.chroot/usr/share/applications
cp $build/repos/* $build/build/config/archives
cp $build/hooks/live/* $build/build/config/hooks/live
cp $build/hooks/normal/* $build/build/config/hooks/normal
cp $build/userconfig/* $build/build/config/includes.chroot/etc/live/config.conf.d
cp $build/lightdm/* $build/build/config/includes.chroot/etc/lightdm

cp -r $build/bootloaders/* $build/build/config/includes.binary
#cp -r $build/configs/* $build/build/config/includes.chroot/etc/

# Build the ISO #
lb build  #--debug --verbose 

