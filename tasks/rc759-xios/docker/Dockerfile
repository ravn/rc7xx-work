FROM ubuntu:22.04
# NASM 2.15.05 er den verificerede version for byte-perfekt XIOS1/XIOS4 output.
# Skift ALDRIG version uden at genkøre build_and_verify_xios.sh og rebuild_and_verify.sh.
RUN apt-get update -qq && \
    apt-get install -qq -y nasm=2.15.05-1 python3 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /work
