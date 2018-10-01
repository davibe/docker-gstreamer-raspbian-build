#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Get gstreamer build dependencies (from here on things are gstreamer-specific)
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
  python3-pip libraspberrypi-dev

# install latest meson
git clone --depth=1 https://github.com/mesonbuild/meson.git
cd meson
pip3 install .
cd ..

# install latest ninja
git clone --depth=1 https://github.com/ninja-build/ninja.git
cd ninja
export CFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE"
./configure.py --bootstrap
cp ninja /usr/sbin/ninja

# omx + libav codec support (TODO: does this work?)
apt-get install -y libomxil-bellagio-dev \
  libavfilter-dev libavformat-dev libavcodec-dev \
  libavdevice-dev libavresample-dev libavutil-dev
