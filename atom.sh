#!/bin/bash

if [ "$1" == "plain" ]; then
# plain mode: don't create any directories
  echo "plain mode ..."
else
  # default mode: gb based filelayout, we need src and vendor/src
  # force the creation to disable warnings in atom. gb and go use
  # different layouts an directory names. and the go-tools need one
  # gb needs the other .... :-(. so try to make both work.

  GO_LIBDIR=`go env GOHOSTOS`_`go env GOARCH`
  GB_LIBDIR=`go env GOHOSTOS`-`go env GOARCH`
  echo "gb/go mode ..."
  mkdir -p /work/vendor/src
  mkdir -p /work/pkg/$GB_LIBDIR
  mkdir -p /work/vendor/pkg/
  cd /work/vendor/pkg && ln -s ../../pkg/$GB_LIBDIR $GO_LIBDIR && cd -
  mkdir -p /work/src
fi

export GOPATH=/devhome/go:/work/vendor:/work
# next one for gometalinter
export GO_VENDOR=1 

/go/bin/gocode set package-lookup-mode gb
/go/bin/gocode set autobuild true

if [ -f "/devhome/.atom/config.cson" ]; then
  # remove old config.cson from previous version
  rm -rf /devhome/.atom/config.cson
fi
if [ ! -f "/config/atocker/config.cson" ]; then
  cp /devhome/config.cson /config/atocker/config.cson
fi
ln -s /config/atocker/config.cson /devhome/.atom/config.cson

if [ ! -d "/devhome/.atom/storage" ]; then
cd /work && $ATOM --foreground .
else
cd /work && $ATOM --foreground
fi
