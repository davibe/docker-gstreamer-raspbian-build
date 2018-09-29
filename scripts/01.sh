#!/bin/bash
echo "deb http://archive.raspbian.org/raspbian stretch firmware" >> /etc/apt/sources.list
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-mark hold
raspberrypi-bootloader raspberrypi-kernel raspberrypi-sys-mods raspi-config
apt-get install -y apt-utils
dpkg-reconfigure apt-utils
apt-get upgrade -y
apt-get install -y libc6-dev symlinks
symlinks -cors /

# Update and Upgrade the Pi, otherwise the build may fail due to inconsistencies
apt-get update && sudo apt-get upgrade -y --force-yes
