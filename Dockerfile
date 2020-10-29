FROM debian:stretch

MAINTAINER Aaron Hansen <aaron.hansen@gatech.edu>
# Copied/adapted from https://github.com/devkitPro/docker/blob/master/devkitarm/Dockerfile

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils vim && \
    apt-get install -y --no-install-recommends sudo ca-certificates pkg-config curl wget bzip2 xz-utils make git bsdtar doxygen gnupg && \
    apt-get clean

RUN wget https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.2/devkitpro-pacman.deb && \
    dpkg -i devkitpro-pacman.deb && \
    rm devkitpro-pacman.deb && \
    dkp-pacman -Scc --noconfirm

ENV DEVKITPRO=/opt/devkitpro
ENV PATH=${DEVKITPRO}/tools/bin:$PATH

RUN dkp-pacman -Syyu --noconfirm gba-dev && \
    dkp-pacman -Scc --noconfirm
ENV DEVKITARM=${DEVKITPRO}/devkitARM
RUN mkdir /gba
COPY wav2c /usr/local/bin
VOLUME ["/gba"]
CMD cd /gba && make