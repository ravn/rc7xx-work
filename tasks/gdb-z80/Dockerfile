FROM ubuntu:24.04
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    build-essential \
    libgmp-dev libmpfr-dev libexpat1-dev libreadline-dev \
    texinfo \
    xz-utils \
    python3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y curl \
 && curl -sLO https://ftp.gnu.org/gnu/gdb/gdb-17.2.tar.xz \
 && tar -xf gdb-17.2.tar.xz && rm gdb-17.2.tar.xz

WORKDIR /src/build
RUN ../gdb-17.2/configure \
        --target=z80-elf \
        --prefix=/opt/z80-elf-gdb \
        --disable-werror \
        --disable-sim \
        --disable-binutils \
        --disable-ld \
        --disable-gas \
        --disable-gprof \
        --without-x \
        --with-expat \
        --with-python=no
RUN make -j$(nproc) all-gdb && make install-gdb

ENTRYPOINT ["/opt/z80-elf-gdb/bin/z80-elf-gdb"]
