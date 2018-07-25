# modified from
# https://raw.githubusercontent.com/cxphong/Build-gstreamer-Raspberry-Pi-3/master/gstreamer-build.sh

[ ! -d src ] && mkdir src

export LD_LIBRARY_PATH=/usr/local/lib/

[ ! -d gstreamer ] && git clone git://anongit.freedesktop.org/git/gstreamer/gstreamer
cd gstreamer
./autogen.sh --disable-gtk-doc
make -j4
sudo make install
cd ..

[ ! -d gst-plugins-base ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base
cd gst-plugins-base
./autogen.sh --disable-gtk-doc
make -j4
sudo make install
cd ..

[ ! -d gst-plugins-good ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good
cd gst-plugins-good
./autogen.sh --disable-gtk-doc
make -j4
sudo make install
cd ..

[ ! -d gst-plugins-ugly ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly
cd gst-plugins-ugly
./autogen.sh --disable-gtk-doc
make -j4
sudo make install
cd ..

[ ! -d gst-plugins-bad ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad
cd gst-plugins-bad
# some extra flags on rpi
./autogen.sh --disable-gtk-doc
export CFLAGS='-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux/'
export LDFLAGS='-L/opt/vc/lib'
./configure CFLAGS='-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux/' LDFLAGS\
--disable-gtk-doc --disable-opengl --enable-gles2 --enable-egl --disable-glx \
--disable-x11 --disable-wayland --enable-dispmanx \
--with-gles2-module-name=/opt/vc/lib/libGLESv2.so \
--with-egl-module-name=/opt/vc/lib/libEGL.so
make CFLAGS+='-Wno-error -Wno-redundant-decls' LDFLAGS+='-L/opt/vc/lib' -j4
sudo make install
cd ..

# omx support
[ ! -d gst-omx ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-omx
cd gst-omx
export LDFLAGS='-L/opt/vc/lib' \
CFLAGS='-I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/IL' \
CPPFLAGS='-I/opt/vc/include -I/opt/vc/include/IL -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/IL'
./autogen.sh --disable-gtk-doc --with-omx-target=rpi
make CFLAGS+='-Wno-error -Wno-redundant-decls' LDFLAGS+='-L/opt/vc/lib' -j4
sudo make install
cd ..

[ ! -d gst-rtsp-server ] && git clone git://anongit.freedesktop.org/git/gstreamer/gst-rtsp-server
cd gst-rtsp-server
./autogen.sh --disable-gtk-doc
make -j4
sudo make install
cd ..

tar -c /usr/local > usr_local.tar