#!/bin/bash

if [ -f "/devhome/.atom/config.cson" ]; then
  # remove old config.cson from previous version
  rm -rf /devhome/.atom/config.cson
fi
if [ ! -f "/config/atocker/config.cson" ]; then
  cp /devhome/config.cson /config/atocker/config.cson
fi
ln -s /config/atocker/config.cson /devhome/.atom/config.cson

cd /work && $ATOM --foreground $DISABLE_GPU .
