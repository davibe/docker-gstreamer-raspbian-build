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

ENV ARCH=arm
ENV CROSS_COMPILE=/bin/$HOST-
ENV QEMU_EXECVE=1

WORKDIR /sysroot

ADD scripts/00_raspbian_chroot_setup.sh /tmp
RUN /bin/bash /tmp/00_raspbian_chroot_setup.sh

ADD scripts/01.sh /sysroot/tmp/01.sh
RUN chroot /sysroot /usr/bin/qemu-arm-static /bin/bash /tmp/01.sh

ADD scripts/02.sh /sysroot/tmp/02.sh
RUN chroot /sysroot /usr/bin/qemu-arm-static /bin/bash /tmp/02.sh

CMD chroot /sysroot /usr/bin/qemu-arm-static /bin/bash