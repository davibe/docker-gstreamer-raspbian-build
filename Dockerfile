FROM debian:stretch

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
  && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  automake \
  cmake \
  curl \
  fakeroot \
  g++ \
  git \
  make \
  runit \
  sudo \
  xz-utils

ENV HOST=arm-linux-gnueabihf \
  TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64

WORKDIR /

RUN curl -L https://github.com/raspberrypi/tools/tarball/master \
  | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/"

ENV ARCH=arm \
  CROSS_COMPILE=/bin/$HOST- \
  PATH=$RPXC_ROOT/bin:$PATH \
  QEMU_PATH=/usr/bin/qemu-arm-static \
  QEMU_EXECVE=1 \
  SYSROOT=/sysroot

WORKDIR $SYSROOT

RUN curl -Ls https://downloads.raspberrypi.org/raspbian_lite/root.tar.xz \
  | tar -xJf -

ADD https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static $SYSROOT/$QEMU_PATH

RUN chmod +x $SYSROOT/$QEMU_PATH && mkdir -p $SYSROOT/build

RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
  echo "deb http://archive.raspbian.org/raspbian stretch firmware" \
  >> /etc/apt/sources.list \
  && apt-get update \
  && sudo apt-mark hold \
  raspberrypi-bootloader raspberrypi-kernel raspberrypi-sys-mods raspi-config \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
  && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libc6-dev \
  symlinks \
  && symlinks -cors /'

# Update and Upgrade the Pi, otherwise the build may fail due to inconsistencies
RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c 'sudo apt-get update && sudo apt-get upgrade -y --force-yes'

# Get gstreamer build dependencies (only this part of the dockerfile is gstreamer specific)
RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
  sudo apt-get install -y --force-yes \
    build-essential autotools-dev automake autoconf \
    libtool autopoint libxml2-dev zlib1g-dev libglib2.0-dev \
    pkg-config bison flex python3 git gtk-doc-tools libasound2-dev \
    libgudev-1.0-dev libxt-dev libvorbis-dev libcdparanoia-dev \
    libpango1.0-dev libtheora-dev libvisual-0.4-dev iso-codes \
    libgtk-3-dev libraw1394-dev libiec61883-dev libavc1394-dev \
    libv4l-dev libcairo2-dev libcaca-dev libspeex-dev libpng-dev \
    libshout3-dev libjpeg-dev libaa1-dev libflac-dev libdv4-dev \
    libtag1-dev libwavpack-dev libpulse-dev libsoup2.4-dev libbz2-dev \
    libcdaudio-dev libdc1394-22-dev ladspa-sdk libass-dev \
    libcurl4-gnutls-dev libdca-dev libdirac-dev libdvdnav-dev \
    libexempi-dev libexif-dev libfaad-dev libgme-dev libgsm1-dev \
    libiptcdata0-dev libkate-dev libmimic-dev libmms-dev \
    libmodplug-dev libmpcdec-dev libofa0-dev libopus-dev \
    librsvg2-dev librtmp-dev libschroedinger-dev libslv2-dev \
    libsndfile1-dev libsoundtouch-dev libspandsp-dev libx11-dev \
    libxvidcore-dev libzbar-dev libzvbi-dev liba52-0.7.4-dev \
    libcdio-dev libdvdread-dev libmad0-dev libmp3lame-dev \
    libmpeg2-4-dev libopencore-amrnb-dev libopencore-amrwb-dev \
    libsidplay1-dev libtwolame-dev libx264-dev libusb-1.0 \
    python-gi-dev yasm python3-dev libgirepository1.0-dev libvo-aacenc-dev \
  '

# install tools that are specifically need to run gst-build
RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c 'apt-get install -y --force-yes python3-pip'
RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c 'git clone https://github.com/mesonbuild/meson.git && cd meson && pip3 install .'

RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c ' \
    git clone https://github.com/ninja-build/ninja.git && \
    cd ninja && \
    export CFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE" && \
    ./configure.py --bootstrap \
  '

# make gst-omx work ?
RUN chroot $SYSROOT $QEMU_PATH /bin/sh -c ' \
  apt-get install -y libomxil-bellagio-dev \
  libavfilter-dev libavformat-dev libavcodec-dev libavdevice-dev libavresample-dev libavutil-dev \
  '

  CMD chroot $SYSROOT $QEMU_PATH /bin/bash

