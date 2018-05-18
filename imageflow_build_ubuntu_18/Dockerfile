FROM ubuntu:18.04

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
    make dpkg-dev g++-8 gcc-8 cmake nasm dh-autoreconf pkg-config \
    git zip curl ccache libpng-dev libssl-dev wget \
    libcurl4-openssl-dev libelf-dev libdw-dev \
  && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 90 \
  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 90 \
  && apt-get install --no-install-recommends -y -q \
  ruby-dev ruby-bundler rubygems-integration luajit \
  python-minimal python-pip python-setuptools valgrind dotnet-sdk-2.1.105 \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && bash -c 'rm -rf {/usr/share/doc,/usr/share/man,/var/cache,/usr/doc,/usr/local/share/doc,/usr/local/share/man}' \
    && bash -c 'rm -rf /usr/local/lib/valgrind/*-x86-*' \
    && bash -c 'rm -rf /usr/lib/valgrind/{power,mips,s390,arm,32bit,i386}*' \
    && bash -c 'rm -rf /usr/local/lib/valgrind/{power,mips,s390,arm,32bit,i386}*' \
  && bash -c 'rm -rf /tmp/*' \
  && bash -c 'rm -rf /var/tmp/*' \
  && sudo mkdir -p /var/cache/apt/archives/partial \
  && sudo touch /var/cache/apt/archives/lock \
  && sudo chmod 640 /var/cache/apt/archives/lock

# Install lcov and  coveralls-lcov
RUN wget -nv  -O lcov.tar.gz http://ftp.de.debian.org/debian/pool/main/l/lcov/lcov_1.11.orig.tar.gz \
    && tar xvzf lcov.tar.gz && rm lcov.tar.gz && mv lcov-1.11 lcov \
    && sudo make -C lcov/ install \
    && rm -rf lcov && rm -rf /usr/share/man \
    && sudo gem install coveralls-lcov

# Install kcov
RUN wget -nv  -O kcov.tar.gz https://github.com/SimonKagstrom/kcov/archive/master.tar.gz \
    && tar xvzf kcov.tar.gz && rm kcov.tar.gz && mv kcov-master kcov \
    && mkdir kcov/build && cd kcov/build \
    && cmake .. && make && sudo make install \
    && cd ../.. && rm -rf kcov && rm -rf /usr/local/share/man

RUN groupadd 1001 -g 1001 &&\
    groupadd 1000 -g 1000 &&\
    useradd -ms /bin/bash conan -g 1001 -G 1000 &&\
    echo "conan:conan" | chpasswd && adduser conan sudo &&\
    echo "conan ALL= NOPASSWD: ALL\n" >> /etc/sudoers &&\
    mkdir -p /home/conan/.conan && sudo chown conan: /home/conan/.conan
USER conan

ENV PATH=/usr/lib/ccache:$PATH
ENV PATH=/home/conan/.cargo/bin:$PATH


#Install nightly Rust and make default
RUN RUSTVER="nightly-2018-05-16" && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUSTVER -v \
    && rustup default $RUSTVER \
    && HI=$(rustup which rustc) && HI=${HI%/bin/rustc} && export TOOLCHAIN_DIR=$HI && echo TOOLCHAIN_DIR=$TOOLCHAIN_DIR \
    && sudo rm -rf $TOOLCHAIN_DIR/share/doc \
    && sudo rm -rf $TOOLCHAIN_DIR/share/man \
    && sudo rm -rf /home/conan/.rustup/toolchains/${RUSTVER}-x86_64-unknown-linux-gnu/share/doc \
    && ln -sf -t $TOOLCHAIN_DIR/lib/ $TOOLCHAIN_DIR/lib/rustlib/x86_64-unknown-linux-gnu/lib/*.so \
    && rustup show \
    && rustc -V

RUN cargo install sccache && cargo install dssim

WORKDIR /home/conan/imageflow

MAINTAINER Nathanael Jones