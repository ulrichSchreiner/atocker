#!/bin/bash

groupadd $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp

# do not use apm's package-file because we want atocker to install
# new packages only if they are not already installed
PACKAGES=( "go-plus" \
  "language-docker" \
  "language-protobuf" \
  "go-rename" \
  "file-icons" \
  "symbols-tree-view" \
  "git-plus" \
  "minimap" \
  "merge-conflicts" \
)

# go-find-references uses git:// scheme, this can block in some environments
# TODO: fix this

for p in "${PACKAGES[@]}"
do
  if [ ! -d "/devhome/.atom/packages/$p" ]; then
    su - $HOSTUSER -c "apm install $p"
  else
    echo "$p already installed."
  fi
done

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

su - $HOSTUSER -c "/devhome/atom.sh '$@'"
