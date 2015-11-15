#!/bin/sh

groupadd $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp
   
if [ ! -d "/devhome/.atom/packages/go-plus" ]; then
su - $HOSTUSER -c "apm install go-plus"
fi
if [ ! -d "/devhome/.atom/packages/language-docker" ]; then
su - $HOSTUSER -c "apm install language-docker"
fi
if [ ! -d "/devhome/.atom/packages/language-protobuf" ]; then
su - $HOSTUSER -c "apm install language-protobuf"
fi
if [ ! -d "/devhome/.atom/packages/go-rename" ]; then
su - $HOSTUSER -c "apm install go-rename"
fi
if [ ! -d "/devhome/.atom/packages/file-icons" ]; then
su - $HOSTUSER -c "apm install file-icons"
fi
if [ ! -d "/devhome/.atom/packages/symbols-tree-view" ]; then
su - $HOSTUSER -c "apm install symbols-tree-view"
fi
if [ ! -d "/devhome/.atom/packages/git-plus" ]; then
su - $HOSTUSER -c "apm install git-plus"
fi

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

su - $HOSTUSER -c "/devhome/atom.sh '$@'"
