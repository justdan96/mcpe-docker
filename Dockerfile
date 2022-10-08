FROM ubuntu:20.04
MAINTAINER Dan Bryant (daniel.bryant@linux.com)

ENV TZ=Europe/London
ENV DEBIAN_FRONTEND=noninteractive 

# install basic dependencies for Linux build
RUN apt-get update
RUN apt-get install -y nano
RUN apt-get install -y software-properties-common
RUN apt-get install -y apt-transport-https
RUN apt-get install -y build-essential g++-multilib
RUN apt-get install -y libc6-dev libfreetype6-dev zlib1g-dev
RUN apt-get install -y checkinstall gcc
RUN apt-get install -y git patch lzma-dev libxml2-dev libssl-dev python curl wget

# common dependencies
RUN apt-get install -y openssl pkg-config libarchive-tools cmake
RUN mkdir -p /usr/local/src
RUN mkdir -p /opt/output

# use Clang + LLVM 10 from repos - rather than compiling 12 from source
RUN apt-get install -y clang llvm

# MSA dependencies
RUN apt-get install -y pip
RUN pip install aqtinstall
RUN cd /usr/local && aqt install-qt linux desktop 6.2.2 -m qtwebengine qtwebview qtwaylandcompositor qt5compat qtwebchannel qtpositioning
RUN mv /usr/local/6.2.2/gcc_64 /usr/local/qt
ENV PATH="/usr/local/qt/bin:$PATH"
ENV CPATH=/usr/local/qt/include
ENV CMAKE_PREFIX_PATH=/usr/local/qt/lib/cmake
ENV Qt6_DIR=/usr/local/qt/lib/cmake/Qt6
RUN echo /usr/local/qt/lib >> /etc/ld.so.conf
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libdrm-dev mesa-common-dev libglu1-mesa-dev curl libcurl4-openssl-dev libxkbcommon-x11-0 \
  libnss3 libnspr4 libxcomposite-dev libxdamage1 libxrender1 libxtst6 libegl-dev libegl1-mesa libxkbfile1 \
  libxrandr2 libfontconfig1 libasound2

COPY get-deps /usr/local/bin/get-deps
RUN chmod +x /usr/local/bin/get-deps
RUN cat /usr/local/bin/get-deps

# launcher dependencies
RUN apt-get install -y ca-certificates \
  libssl-dev libpng-dev libx11-dev libxi-dev libcurl4-openssl-dev libudev-dev \
  libevdev-dev libegl1-mesa-dev libssl-dev libasound2 \
  autoconf autotools-dev automake libtool texinfo

# launcher UI dependencies
RUN apt-get install -y libprotobuf-dev protobuf-compiler libzip-dev

# install linuxdeploy and the Qt plugin
RUN curl -sLo /usr/local/bin/linuxdeploy-x86_64.AppImage "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage" 
RUN curl -sLo /usr/local/bin/linuxdeploy-plugin-qt-x86_64.AppImage \
  "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage" 
RUN chmod +x /usr/local/bin/linuxdeploy-x86_64.AppImage
RUN chmod +x /usr/local/bin/linuxdeploy-plugin-qt-x86_64.AppImage

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# fix for issue of linuxdeploy in Docker containers
RUN dd if=/dev/zero of=/usr/local/bin/linuxdeploy-x86_64.AppImage conv=notrunc bs=1 count=3 seek=8
RUN dd if=/dev/zero of=/usr/local/bin/linuxdeploy-plugin-qt-x86_64.AppImage conv=notrunc bs=1 count=3 seek=8

# clean up all sources
RUN rm -rf /usr/local/src/*

# cleanup script from https://github.com/kubernetes-sigs/kind/blob/main/images/base/files/usr/local/bin/clean-install
RUN apt-get clean -y
RUN rm -rf \
   /var/cache/debconf/* \
   /var/lib/apt/lists/* \
   /var/log/* \
   /tmp/* \
   /var/tmp/* \
   /usr/share/doc/* \
   /usr/share/doc-base/* \
   /usr/share/man/* \
   /usr/share/local/*
