#!/bin/sh

groupadd $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp
   
if [ ! -d "/devhome/.atom/packages/go-plus" ]; then
su - $HOSTUSER -c "apm install go-plus"
fi

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

su - $HOSTUSER -c /devhome/atom.sh
