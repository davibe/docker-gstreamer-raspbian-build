#!/bin/bash
echo "Warning: This scripts creates prepares chroot env in the CURRENT DIRECTORY"

mkdir -p usr/bin/
curl \
  -L https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static \
  > usr/bin/qemu-arm-static
curl -Ls https://downloads.raspberrypi.org/raspbian_lite/root.tar.xz | tar -xJf -
chmod +x ./usr/bin/qemu-arm-static 