FROM debian:jessie
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>
# base copied from Jessica Frazell

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gconf2 \
    gconf-service \
    git \
    mercurial \
    bzr \
    gvfs-bin \
    libasound2 \
    libgconf-2-4 \
    libgnome-keyring-dev \
    libgtk2.0-0 \
    libnotify4 \
    libnss3 \
    libxtst6 \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV ATOM_VERSION 1.2.4

RUN curl -sSL https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb -o /tmp/atom-amd64.deb \
	&& dpkg -i /tmp/atom-amd64.deb \
	&& rm -rf /tmp/atom-amd64.deb

ENV GO_VERSION 1.5.1
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz

RUN mkdir /go && cd /go && mkdir src pkg bin
ENV GOPATH /go

RUN /usr/local/go/bin/go get \
    github.com/nsf/gocode \
    github.com/golang/lint/golint \
    golang.org/x/tools/cmd/goimports \
    github.com/rogpeppe/godef \
    golang.org/x/tools/cmd/oracle \
    golang.org/x/tools/cmd/stringer \
    github.com/josharian/impl \
    golang.org/x/tools/cmd/gorename \
    github.com/redefiance/go-find-references \
    github.com/constabulary/gb/...

RUN echo "PATH=/usr/local/go/bin:/go/bin:$PATH" > /etc/profile.d/go.sh

RUN mkdir /devhome
ADD startup.sh /devhome/startup.sh
ADD atom.sh /devhome/atom.sh
ADD config.cson /devhome/config.cson

VOLUME /work

ENTRYPOINT ["/devhome/startup.sh"]
