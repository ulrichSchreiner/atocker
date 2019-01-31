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
  "atom-jinja2" \
  "atom-terminal" \
  "auto-reveal-in-sidebar" \
  "blame" \
  "environment" \
  "file-icons" \
  "firacode" \
  "git-control" \
  "git-history" \
  "git-log" \
  "git-plus" \
  "git-time-machine" \
  "language-ansible" \
  "language-docker" \
  "language-protobuf" \
  "language-restructuredtext" \
  "linter" \
  "merge-conflicts" \
  "minimap" \
  "minimap-bookmarks" \
  "minimap-find-and-replace" \
  "react" \
  "rst-preview-pandoc" \
  "tool-bar" \
  "tool-bar-almighty" \
)

UNINSTALL=(
  "go-debug" \
  "go-plus" \
  "go-signature-statusbar"
)

for p in "${PACKAGES[@]}"
do
  if [ ! -d "/devhome/.atom/packages/$p" ]; then
    gosu $HOSTUSER $APM install $p
  else
    echo "$p already installed."
  fi
done

for p in "${UNINSTALL[@]}"
do
  if [ -d "/devhome/.atom/packages/$p" ]; then
    gosu $HOSTUSER $APM uninstall $p
  fi
done

exec gosu $HOSTUSER bash -c "export PATH=/usr/local/go/bin:/go/bin:$PATH ATOM=$ATOM export LANG=$LANG && dbus-launch /devhome/atom.sh '$@'"
