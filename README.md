# Readme

I created this Dockerfile to build gstreamer and plugins from git for the raspberry pi.
In this case I am not using a real cross-compiler. I just run the entyre build inside
qemu-static-arm that runs in a raspbian chroot. 
This is way faster than full system emulation yet slower than real cross-compilation.
It took 2 - 3 hrs on my macbook pro.

Here is how to use it

    docker build -t raspbian-chroot .

    docker run --rm -it -v $(pwd)/build:/sysroot/build raspi-chroot

This will open a bash terminal.
This bash terminal lives inside the emulated raspberry chroot like this

    docker container -> chroot raspberry filesystem -> qemu-arm-static -> bash

`build` is mounted to `/sysroot/build` which you see as `/build` in the chrooted fs.

So you can do

    cd build
    bash build.sh
    # whatever

