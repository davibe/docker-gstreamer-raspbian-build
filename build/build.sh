# modified from
# https://raw.githubusercontent.com/cxphong/Build-gstreamer-Raspberry-Pi-3/master/gstreamer-build.sh

# export LD_LIBRARY_PATH=/usr/local/lib/

export PATH=$PATH:/ninja

git clone --depth=1 https://github.com/GStreamer/gst-build.git
cd gst-build
meson build
ninja -C build -j 10
# ninja -C build uninstalled
# ninja -C build install

# TODO: include in the gst-build process
[ ! -d rtsprelay ] && git clone https://github.com/jayridge/rtsprelay
cd rtsprelay
make -j4
sudo make install
cd ..

tar -c /usr/local > usr_local.tar
