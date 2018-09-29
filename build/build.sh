export PATH=$PATH:/ninja

git clone --depth=1 https://github.com/GStreamer/gst-build.git
cd gst-build
meson build
ninja -C build -j 10

DESTDIR=$(pwd)/prefix ninja -C build install # takes longer than expected, ignore final errors
tar prefix > prefix.tar

# TODO: include in the gst-build process
[ ! -d rtsprelay ] && git clone https://github.com/jayridge/rtsprelay
cd rtsprelay
make -j4
sudo make install
cd ..

tar -c /usr/local > usr_local.tar
