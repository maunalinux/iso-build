#!/bin/bash

################################################################################
# Title:        build-mate.sh
# Description:  Script to build Mauna MATE ISO image
# Author:       Mauna Linux <dev@maunalinux.top>
# Date:         20 Dezembro, 2023
# License:      GPL-3.0-or-later
################################################################################


PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"

# Set the working folder variable
maunabuild="$(pwd)"


# Create the build folder, move into it removing stale mountpoints and files there.
[ -e build ] && [ ! -d build ] && rm -f build || [ ! -e build ] && mkdir build
cd build
umount $(mount | grep "${PWD}/chroot" | tac | cut -f3 -d" ") 2>/dev/null
for i in ./* ./.build ./cache/bootstrap ; do [ $i = ./cache ] && continue || rm -rf $i ; done

# Set of the structure to be used for the ISO and Live system.
# See /usr/lib/live/build/config for a full list of examples.
# Up above is the manual description of what options I used so far.
lb config noauto \
	--binary-images iso-hybrid \
	--mode debian \
	--architectures "amd64" \
	--linux-flavours "amd64" \
	--distribution "bookworm" \
        --parent-distribution bookworm \
	--archive-areas "main contrib non-free non-free-firmware" \
        --parent-debian-installer-distribution "bookworm" \
        --debian-installer "live" \
	--updates "true" \
        --interactive shell \
	--security true \
	--backports false \
	--cache true \
	--firmware-chroot false \
	--firmware-binary false \
	--apt-recommends true \
	--utc-time true \
	--uefi-secure-boot enable \
	--initramfs live-boot \
	--iso-application Mauna \
	--iso-preparer Mauna-https://maunalinux.top \
	--iso-publisher Mauna-https://maunalinux.top \
	--iso-volume MaunaLinux \
	--image-name "MaunaLinux-24.0.1-Testing-MATE" \
	--win32-loader false \
	--checksums sha512 \
	--zsync false \        
     "${@}"

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

" > $maunabuild/build/config/package-lists/installer.list.binary 

# Setup the chroot structure
mkdir -p $maunabuild/build/config/archives
mkdir -p $maunabuild/build/config/includes.binary
mkdir -p $maunabuild/build/config/hooks/live
mkdir -p $maunabuild/build/config/hooks/normal
mkdir -p $maunabuild/build/config/bootloaders
mkdir -p $maunabuild/build/config/includes.chroot/usr/share/applications
mkdir -p $maunabuild/build/config/includes.chroot/etc/live/config.conf.d
mkdir -p $maunabuild/build/config/includes.chroot/usr/share/distro-info
mkdir -p $maunabuild/build/config/includes.chroot//usr/share/python-apt/templates
mkdir -p $maunabuild/build/config/includes.chroot/etc/dpkg/origins

# Copy Configs to the chroot

cp -r $maunabuild/maunaapplication/*  $maunabuild/build/config/includes.chroot/usr/share/applications
cp -r $maunabuild/maunabootloaders/* $maunabuild/build/config/includes.binary
cp -r $maunabuild/maunauserconfig/* $maunabuild/build/config/includes.chroot/etc/live/config.conf.d
cp -r $maunabuild/configs/* $maunabuild/build/config/includes.chroot/etc/
cp $maunabuild/hooks/live/* $maunabuild/build/config/hooks/live
cp $maunabuild/hooks/normal/* $maunabuild/build/config/hooks/normal

#symlinks chroot
ln -s mauna $maunabuild/build/config/includes.chroot/etc/dpkg/origins/default

# Build ISO #
lb build  #--debug --verbose 
