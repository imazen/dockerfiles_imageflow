FROM ubuntu:18.04

# We'll leave the Ubuntu 14.04 and 18.04 images light, and only install valgrind/coverage/bindings on 16.04

# The cleaner layers approach is commented out, since docker hub doesn't support --squash
#RUN apt-get update \
#    && apt-get install --no-install-recommends -y gnupg ca-certificates sudo
#
#RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/dotnetdev.list' \
#    && apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF \
#    && apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893 \
#    && apt-get update
#
#MAINTAINER Nathanael Jones
#
## Add -q where possible
#
#RUN apt-get install  --no-install-recommends -y -q \
#    make dpkg-dev g++-8 gcc-8 cmake nasm dh-autoreconf pkg-config \
#  && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 90 \
#  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 90
#
#
#RUN apt-get install --no-install-recommends -y -q \
#    git zip curl ccache libpng-dev libssl-dev wget \
#    libcurl4-openssl-dev libelf-dev libdw-dev
#
#RUN  apt-get install --no-install-recommends -y -q \
#  ruby-dev ruby-bundler rubygems-integration \
#  luajit \
#  python-minimal python-pip python-setuptools valgrind dotnet-sdk-2.1.105


RUN apt-get update \
    && apt-get install --no-install-recommends -y gnupg ca-certificates sudo \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893 \
    && apt-get update \
    && apt-get install  --no-install-recommends -y -q \
    build-essential nasm dh-autoreconf pkg-config \
    git zip curl libpng-dev libssl-dev wget \
    libcurl4-openssl-dev libelf-dev libdw-dev \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && bash -c 'rm -rf {/usr/share/doc,/usr/share/man,/var/cache,/usr/doc,/usr/local/share/doc,/usr/local/share/man}' \
    && bash -c 'rm -rf /usr/local/lib/valgrind/*-x86-*' \
    && bash -c 'rm -rf /usr/lib/valgrind/{power,mips,s390,arm,32bit,i386}*' \
    && bash -c 'rm -rf /usr/local/lib/valgrind/{power,mips,s390,arm,32bit,i386}*' \
  && bash -c 'rm -rf /tmp/* || true' \
  && bash -c 'rm -rf /var/tmp/*' \
  && sudo mkdir -p /var/cache/apt/archives/partial \
  && sudo touch /var/cache/apt/archives/lock \
  && sudo chmod 640 /var/cache/apt/archives/lock

RUN groupadd 1001 -g 1001 &&\
    groupadd 1000 -g 1000 &&\
    useradd -ms /bin/bash imageflow -g 1001 -G 1000 &&\
    echo "imageflow:imageflow" | chpasswd && adduser imageflow sudo &&\
    echo "imageflow ALL= NOPASSWD: ALL\n" >> /etc/sudoers

USER imageflow

ENV PATH=/home/imageflow/.cargo/bin:$PATH

#Install beta Rust and make default
RUN RUSTVER="beta-2018-06-30" && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUSTVER -v \
    && rustup default $RUSTVER \
    && HI=$(rustup which rustc) && HI=${HI%/bin/rustc} && export TOOLCHAIN_DIR=$HI && echo TOOLCHAIN_DIR=$TOOLCHAIN_DIR \
    && sudo rm -rf $TOOLCHAIN_DIR/share/doc \
    && sudo rm -rf $TOOLCHAIN_DIR/share/man \
    && sudo rm -rf /home/conan/.rustup/toolchains/${RUSTVER}-x86_64-unknown-linux-gnu/share/doc \
    && ln -sf -t $TOOLCHAIN_DIR/lib/ $TOOLCHAIN_DIR/lib/rustlib/x86_64-unknown-linux-gnu/lib/*.so \
    && rustup show \
    && rustc -V

RUN PKG_CONFIG_ALL_STATIC=1 cargo install --force --git=https://github.com/mozilla/sccache.git --features=s3 \
    && PKG_CONFIG_ALL_STATIC=1 cargo install dssim

WORKDIR /home/imageflow/imageflow


MAINTAINER Nathanael Jones