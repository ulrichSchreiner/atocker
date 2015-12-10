#!/bin/bash

locale-gen $LANG

groupadd $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -G video -M -d /devhome
mkdir -p /devhome/.local/share
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp

if [ ! -d "/config/atocker$WORKSPACE" ]; then
su $HOSTUSER -c "mkdir -p /config/atocker$WORKSPACE"
fi
ln -s /config/atocker$WORKSPACE /devhome/.atom

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
  "atom-material-ui" \
  "atom-material-syntax" \
  "react" \
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

if [ ! -d "/devhome/.atom/atom-go-find-references" ]; then
  cd /devhome/.atom
  git clone https://github.com/redefiance/atom-go-find-references.git
  chown -R $HOSTUSER:$HOSTGROUP atom-go-find-references
  cd /devhome/.atom/atom-go-find-references
  sed -i 's/git\:\/\//git\+https\:\/\//g' package.json
  su $HOSTUSER -c "apm install && apm link"
fi

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

su $HOSTUSER -c "export LANG=$LANG && /devhome/atom.sh '$@'"
