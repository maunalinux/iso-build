#!/bin/bash
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
	--bootstrap-qemu-arch arm64 \
	--architectures arm64 \
	--linux-flavours arm64 \
	--bootloaders grub-efi \
	--distribution bookworm \
	--archive-areas "main contrib non-free non-free-firmware" \
	--mirror-bootstrap https://deb.debian.org/debian \
	--bootstrap-qemu-static /usr/sbin/qemu-debootstrap \
	--parent-mirror-bootstrap https://deb.debian.org/debian \
	--parent-mirror-chroot https://deb.debian.org/debian \
	--parent-mirror-chroot-security https://security.debian.org/debian-security  \
	--parent-mirror-binary https://deb.debian.org/debian \
	--parent-mirror-binary-security https://security.debian.org/debian-security  \
	--mirror-chroot https://deb.debian.org/debian \
	--mirror-chroot-security https://security.debian.org/debian-security \
	--updates true \
	--security true \
	--backports false \
	--cache true \
	--apt-recommends true \
	--iso-application Mauna \
	--win32-loader false \
	--iso-preparer Mauna-https://maunalinux.top \
	--iso-publisher Mauna-https://maunalinux.top \
	--iso-volume MaunaLinux \
	--image-name "MaunaLinux" \
	--win32-loader false \
	--checksums sha512 \
	--zsync false \
     "${@}"


# Install the Lxqt Desktop 
mkdir -p $build/build/config/package-lists
echo lxqt > $build/build/config/package-lists/desktop.list.chroot 

# Install software
echo "# Install software to the squashfs for calamares to unpack to the OS.
linux-headers-arm64
lxqt-archiver
lxqt-archiver-l10n
locales
nala
dbus-x11
ntp
mauna-keyring
mauna-sources
mauna-translations
mauna-about
maunasystem
debian-system-adjustments
xorg 
xserver-xorg 
xserver-xorg-input-synaptics 
xserver-xorg-input-all  
xserver-xorg-video-all
pulseaudio 
pavucontrol-qt 
alsa-utils
aptitude 
synaptic  
apt-config-auto-update 
libelf-dev 
htop 
desktop-base 
mauna-update
gparted
gimp
dmidecode
gvfs-backends 
samba 
network-manager 
network-manager-gnome
bluez 
blueman
gufw
grub2-theme-mauna
grub2-theme-mauna-2k
materia-kde
qt5-style-kvantum
qt5-style-kvantum-l10n
qt5-style-kvantum-themes
materia-gtk-theme
tela-icon-theme
gtk2-engines-aurora 
gtk2-engines 
plymouth 
plymouth-themes
cups 
system-config-printer 
lightdm 
lightdm-gtk-greeter 
lightdm-gtk-greeter-settings
dbus-tests
xscreensaver 
xscreensaver-data 
xscreensaver-data-extra 
xscreensaver-gl 
xscreensaver-gl-extra
gnome-system-tools 
gnome-disk-utility
gnome-calculator 
neofetch 
accountsservice 
timeshift
fwupd 
dconf-editor
xsane
transmission-gtk 
firefox-esr
firefox-esr-l10n-pt-br
printer-driver-cups-pdf
gnome-2048 
gnome-chess 
gnome-mahjongg 
gnome-sudoku
guvcview 
vlc 
xfburn
maunainstall
gdebi 
f2fs-tools
xfsprogs
xfsdump
xfce4
xsettingsd
console-setup
spice-vdagent
calamares
calamares-settings-mauna-arm

" > $build/build/config/package-lists/packages.list.chroot 

# Packages to be stored in /pool but not installed in the OS .
echo "# These packages are available to the installer, for offline use. 
efibootmgr
grub-common
grub2-common
grub-efi
grub-efi-arm64
grub-efi-arm64-bin
grub-efi-arm64-signed
libefiboot1
libefivar1
mokutil
os-prober
shim-helpers-arm64-signed
shim-signed
shim-signed-common
shim-unsigned

" > $build/build/config/package-lists/installer.list.binary 

# Uncomment to install calamares
#mkdir -p $build/build/config/includes.chroot/etc/calamares
#mkdir -p $build/build/config/includes.chroot/usr/sbin
#mkdir -p $build/build/config/includes.chroot/usr/share/pixmaps

#cp -r $build/calamares/calamares/* $build/build/config/includes.chroot/etc/calamares
#cp $build/calamares/sources-final $build/build/config/includes.chroot/usr/sbin
#cp $build/calamares/install-debian.png $build/build/config/includes.chroot/usr/share/pixmaps

#echo "
#calamares 
#calamares-settings-debian

#" >> $build/build/config/package-lists/calamares.list.chroot

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

