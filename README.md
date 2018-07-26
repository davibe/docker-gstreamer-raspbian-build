# Readme

I created this Dockerfile to build gstreamer and plugins from git for the raspberry pi.
In this case I am not using a real cross-compiler. I just run the entyre build inside
qemu-static-arm that runs in a raspbian chroot. 
This is way faster than full system emulation yet slower than real cross-compilation.
It took 2 - 3 hrs on my macbook pro.

If you just want to download prebuilt binaries skip to [Installing](#installing)

## Building

    docker build -t raspbian-chroot .

    docker run --rm -it -v $(pwd)/build:/sysroot/build raspbian-chroot

This will open a bash terminal.
This bash terminal lives inside the emulated raspberry chroot like this

    docker container -> chroot raspberry filesystem -> qemu-arm-static -> bash

`build` is mounted to `/sysroot/build` which you see as `/build` in the chrooted fs.

So you can do

    cd build
    bash build.sh
    # whatever

The build.sh script generates a new version of `build/usr_local.tar`.

# Installing

In order to install the prebuilt gstreamer you can transfer 
and decompress `build/usr_local.tar` to your raspberry and then

    scp build/usr_local.tar pi@raspberrypi.local:~
    ssh pi@raspberrypi.local
    sudo apt-get remove gstreamer-1.0 # remove raspbian version of gstreamer
    cd /
    tar -xvf /home/pi/usr_local.tar
    export LD_LIBRARY_PATH=/usr/local/lib
    gst-inspect-1.0 --version # enjoy

