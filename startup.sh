#!/bin/sh

groupadd $HOSTGROUP
useradd $HOSTUSER -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp

su - $HOSTUSER -c "GOPATH=/devhome/go:/work GO15VENDOREXPERIMENT=1 /devhome/installgotools.sh"
    
if [ ! -d "/devhome/.atom/packages/go-plus" ]; then
su - $HOSTUSER -c "apm install go-plus"
fi

su - $HOSTUSER -c "GOPATH=/devhome/go:/work GO15VENDOREXPERIMENT=1 cd /work && atom --foreground"
