FROM ubuntu:trusty

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
  sudo build-essential nasm dh-autoreconf pkg-config ca-certificates gnupg apt-transport-https cmake3  \
  wget zip libcurl4-openssl-dev libelf-dev libdw-dev curl libssl-dev zlib1g-dev git \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && bash -c 'rm -rf {/usr/share/doc,/usr/share/man,/var/cache,/usr/doc,/usr/local/share/doc,/usr/local/share/man}' \
  && bash -c 'rm -f /tmp/*' \
  && bash -c 'rm -f /var/tmp/*' \
  && sudo mkdir -p /var/cache/apt/archives/partial \
  && sudo touch /var/cache/apt/archives/lock \
  && sudo chmod 640 /var/cache/apt/archives/lock

RUN wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb \
  && sudo dpkg -i packages-microsoft-prod.deb \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
  luajit \
  python-minimal \
  ruby-dev ruby-bundler \
  && apt-get clean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && bash -c 'rm -rf {/usr/share/doc,/usr/share/man,/var/cache,/usr/doc,/usr/local/share/doc,/usr/local/share/man}' \
  && bash -c 'rm -f /tmp/* || true' \
  && bash -c 'rm -f /var/tmp/*' \
  && sudo mkdir -p /var/cache/apt/archives/partial \
  && sudo touch /var/cache/apt/archives/lock \
  && sudo chmod 640 /var/cache/apt/archives/lock


#  dotnet-sdk-2.1.200 \

# Install kcov
RUN wget  -nv -O kcov.tar.gz https://github.com/SimonKagstrom/kcov/archive/master.tar.gz \
    && tar xvzf kcov.tar.gz && rm kcov.tar.gz && mv kcov-master kcov \
    && mkdir kcov/build \
    && cd kcov/build \
    && cmake .. \
    && make \
    && sudo make install \
    && cd ../.. \
    && rm -rf kcov \
    && rm -rf /usr/local/share/man

# Install lcov
RUN wget  -nv -O lcov.tar.gz http://ftp.de.debian.org/debian/pool/main/l/lcov/lcov_1.11.orig.tar.gz \
    && tar xvzf lcov.tar.gz && rm lcov.tar.gz && mv lcov-1.11 lcov \
    && sudo make -C lcov/ install \
    && rm -rf lcov && rm -rf /usr/share/man

RUN groupadd 1001 -g 1001 &&\
    groupadd 1000 -g 1000 &&\
    useradd -ms /bin/bash conan -g 1001 -G 1000 &&\
    echo "conan:conan" | chpasswd && adduser conan sudo &&\
    echo "conan ALL= NOPASSWD: ALL\n" >> /etc/sudoers &&\
    mkdir -p /home/conan/.conan && sudo chown conan: /home/conan/.conan

USER conan

ENV PATH=/home/conan/.cargo/bin:$PATH

#Install nightly Rust and make default
RUN RUSTVER="nightly-2018-05-15" && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $RUSTVER -v \
    && rustup default $RUSTVER \
    && HI=$(rustup which rustc) && HI=${HI%/bin/rustc} && export TOOLCHAIN_DIR=$HI && echo TOOLCHAIN_DIR=$TOOLCHAIN_DIR \
    && sudo rm -rf $TOOLCHAIN_DIR/share/doc \
    && sudo rm -rf $TOOLCHAIN_DIR/share/man \
    && sudo rm -rf /home/conan/.multirust/toolchains/${RUSTVER}-x86_64-unknown-linux-gnu/share/doc \
    && ln -sf -t $TOOLCHAIN_DIR/lib/ $TOOLCHAIN_DIR/lib/rustlib/x86_64-unknown-linux-gnu/lib/*.so \
    && rustup show \
    && rustc -V

RUN PKG_CONFIG_ALL_STATIC=1 cargo install --force --git=https://github.com/mozilla/sccache.git --features=s3 \
    && PKG_CONFIG_ALL_STATIC=1 cargo install dssim \

WORKDIR /home/conan/imageflow


MAINTAINER Nathanael Jones
