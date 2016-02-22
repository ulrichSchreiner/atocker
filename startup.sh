#!/bin/bash

APM=/usr/bin/apm
ATOM=/usr/bin/atom

if [ -f "/usr/bin/apm-beta" ]; then
  APM=/usr/bin/apm-beta
  ATOM=/usr/bin/atom-beta
fi

locale-gen $LANG

groupadd $HOSTGROUP -g $HOSTGROUPID
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -G video -M -d /devhome
mkdir -p /devhome/.local/share
chown -R $HOSTUSER:$HOSTGROUP /devhome
chmod 777 /tmp

if [ ! -d "/config/atocker$WORKSPACE/.atom" ]; then
su $HOSTUSER -c "mkdir -p /config/atocker$WORKSPACE/.atom"
fi
if [ ! -d "/config/atocker/.atom/packages" ]; then
su $HOSTUSER -c "mkdir -p /config/atocker/.atom/packages"
fi
if [ ! -d "/config/atocker$WORKSPACE/Atom" ]; then
su $HOSTUSER -c "mkdir -p /config/atocker$WORKSPACE/Atom"
fi

su $HOSTUSER -c "mkdir -p /devhome/.config"

ln -s /config/atocker$WORKSPACE/.atom /devhome/.atom
# remove old packages from previous version
rm -rf /devhome/.atom/packages
ln -s /config/atocker/.atom/packages /devhome/.atom/packages
ln -s /config/atocker$WORKSPACE/Atom /devhome/.config/Atom

# do not use apm's package-file because we want atocker to install
# new packages only if they are not already installed
PACKAGES=(
  "atom-material-syntax" \
  "atom-material-syntax-light" \
  "atom-material-ui" \
  "atom-terminal" \
  "blame" \
  "file-icons" \
  "git-control" \
  "git-history" \
  "git-log" \
  "git-plus" \
  "go-plus" \
  "go-rename" \
  "language-docker" \
  "language-protobuf" \
  "language-reStructuredText" \
  "merge-conflicts" \
  "minimap" \
  "minimap-bookmarks" \
  "minimap-find-and-replace" \
  "react" \
  "rst-preview-pandoc" \
  "symbols-tree-view" \
  "tool-bar" \
  "tool-bar-almighty" \
)

# go-find-references uses git:// scheme, this can block in some environments
# TODO: fix this

for p in "${PACKAGES[@]}"
do
  if [ ! -d "/devhome/.atom/packages/$p" ]; then
    gosu $HOSTUSER $APM install $p
  else
    echo "$p already installed."
  fi
done

if [ ! -d "/config/atocker/.atom/atom-go-find-references" ]; then
  cd /config/atocker/.atom
  git clone https://github.com/redefiance/atom-go-find-references.git
  chown -R $HOSTUSER:$HOSTGROUP atom-go-find-references
  cd /config/atocker/.atom/atom-go-find-references
  sed -i 's/git\:\/\//git\+https\:\/\//g' package.json
  gosu $HOSTUSER $APM install && $APM link
fi

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

exec gosu $HOSTUSER bash -c "export ATOM=$ATOM export LANG=$LANG && dbus-launch /devhome/atom.sh '$@'"
