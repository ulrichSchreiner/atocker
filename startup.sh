#!/bin/sh

groupadd $HOSTGROUP
useradd $HOSTUSER -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp

if [ ! -d "/devhome/.atom/packages/go-plus" ]; then
su - $HOSTUSER -c "apm install go-plus"
fi

su - $HOSTUSER -c "cd /work && atom --foreground"
