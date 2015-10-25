FROM debian:jessie

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gconf2 \
    gconf-service \
    git \
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

ENV ATOM_VERSION 1.0.19

RUN curl -sSL https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb -o /tmp/atom-amd64.deb \
	&& dpkg -i /tmp/atom-amd64.deb \
	&& rm -rf /tmp

RUN curl https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz |tar -C /usr/local -xz
RUN echo "PATH=/usr/local/go/bin:$PATH" > /etc/profile.d/go.sh

RUN mkdir /devhome
ADD startup.sh /devhome/startup.sh
ADD installgotools.sh /devhome/installgotools.sh

VOLUME /work

CMD /devhome/startup.sh