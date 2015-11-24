#!/bin/bash

if [ "$1" == "plain" ]; then
# plain mode: don't create any directories
  echo "plain mode ..."
else
  # default mode: gb based filelayout, we need src and vendor/src
  # force the creation to disable warnings in atom
  echo "gb/go mode ..."
  mkdir -p /work/vendor/src
  mkdir -p /work/src
fi

export GOPATH=/devhome/go:/work/vendor:/work 
export GO15VENDOREXPERIMENT=1 

/go/bin/gocode set package-lookup-mode gb

if [ ! -f "/devhome/.atom/config.cson" ]; then
  cp /devhome/config.cson /devhome/.atom/config.cson
fi

if [ ! -d "/devhome/.atom/storage" ]; then
cd /work && exec atom --foreground .
else
cd /work && exec atom --foreground
fi
