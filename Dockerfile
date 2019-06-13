FROM ubuntu:19.04
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

ENV ATOM_VERSION 1.38.1

RUN apt-get update && apt-get install -y \
    build-essential \
    bzr \
    ca-certificates \
    chromium-browser \
    curl \
    dbus-x11 \
    gconf2 \
    gconf-service \
    git \
    gvfs-bin \
    mercurial \
    libasound2 \
    libcanberra-gtk-module \
    libcap2 \
    libexif-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgconf-2-4 \
    libgnome-keyring-dev \
    libgtk2.0-0 \
    libnotify4 \
    libnss3 \
    libpango-1.0-0 \
    libsecret-1-dev \
    libv4l-0 \
    libxkbfile1 \
    libxss1 \
    libxtst6 \
    locales \
    openssh-client \
    pandoc \
    python-dev \
    pylint \
    shellcheck \
    wget \
    xdg-utils \
    xterm \
    --no-install-recommends \
    && rm -rf /var/lib/apt/*

RUN curl -sSL https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb -o /tmp/atom-amd64.deb \
    && dpkg -i /tmp/atom-amd64.deb \
    && rm -rf /tmp/atom-amd64.deb \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && chmod +x /usr/bin/gosu

RUN mkdir /devhome 
COPY startup.sh /devhome/startup.sh
COPY atom.sh /devhome/atom.sh
COPY config.cson /devhome/config.cson
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

VOLUME /work

ENTRYPOINT ["/devhome/startup.sh"]
