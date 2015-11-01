#!/bin/sh

# force the creation to disable warnings in atom
mkdir -p /work/vendor/src
mkdir -p /work/src
export GOPATH=/devhome/go:/work/vendor:/work 
export GO15VENDOREXPERIMENT=1 

/go/bin/gocode set package-lookup-mode gb

if [ ! -f "/devhome/.atom/config.cson" ]; then
  cp /devhome/config.cson /devhome/.atom/config.cson
fi

if [ ! -d "/devhome/.atom/storage" ]; then
cd /work && atom --foreground .
else
cd /work && atom --foreground
fi
