FROM ubuntu:16.04
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apt-get update && apt-get install -y \
    build-essential \
    bzr \
    ca-certificates \
    curl \
    gconf2 \
    gconf-service \
    git \
    gvfs-bin \
    mercurial \
    libasound2 \
    libcanberra-gtk-module \
    libexif-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libgconf-2-4 \
    libgnome-keyring-dev \
    libgtk2.0-0 \
    libnotify4 \
    libnss3 \
    libpango-1.0-0 \
    libv4l-0 \
    libxkbfile1 \
    libxss1 \
    libxtst6 \
    openssh-client \
    pandoc \
    python-dev \
    pylint \
    shellcheck \
    wget \
    xdg-utils \
    xterm \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV ATOM_VERSION 1.12.5

RUN curl -sSL https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb -o /tmp/atom-amd64.deb \
	&& dpkg -i /tmp/atom-amd64.deb \
	&& rm -rf /tmp/atom-amd64.deb

ENV GO_VERSION 1.7.3
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz

RUN mkdir /go && cd /go && mkdir src pkg bin

ENV GB_VERSION 0.4.1
RUN GOPATH=/go PATH=/usr/local/go/bin:$PATH go get \
    github.com/constabulary/gb/... \
    github.com/alecthomas/gometalinter \
    github.com/josharian/impl \
    github.com/nsf/gocode \
    github.com/rogpeppe/godef \
    golang.org/x/tools/cmd/gorename \
    golang.org/x/tools/cmd/gotype \
    golang.org/x/tools/cmd/stringer \
    github.com/zmb3/gogetdoc \
    github.com/derekparker/delve/cmd/dlv && \
    GOPATH=/go PATH=/usr/local/go/bin:$PATH /go/bin/gometalinter --install && \
    rm -rf /go/pkg/*


RUN echo "PATH=/usr/local/go/bin:/go/bin:$PATH" > /etc/profile.d/go.sh
RUN ln -sf /go/bin/* /usr/bin/

RUN curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && chmod +x /usr/bin/gosu

RUN mkdir /devhome
COPY startup.sh /devhome/startup.sh
COPY atom.sh /devhome/atom.sh
COPY config.cson /devhome/config.cson
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

VOLUME /work

ENTRYPOINT ["/devhome/startup.sh"]
