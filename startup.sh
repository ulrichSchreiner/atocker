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
  "autocomplete-go" \
  "builder-go" \
  "blame" \
  "environment" \
  "file-icons" \
  "git-control" \
  "git-history" \
  "git-log" \
  "git-plus" \
  "git-time-machine" \
  "go-config" \
  "go-get" \
  "go-plus" \
  "go-signature-statusbar" \
  "gofmt" \
  "gorename" \
  "language-ansible" \
  "language-docker" \
  "language-protobuf" \
  "language-restructuredtext" \
  "linter" "gometalinter-linter" \
  "merge-conflicts" \
  "minimap" \
  "minimap-bookmarks" \
  "minimap-find-and-replace" \
  "navigator-godef" \
  "react" \
  "rst-preview-pandoc" \
  "symbols-tree-view" \
  "tester-go" \
  "tool-bar" \
  "tool-bar-almighty" \
)


for p in "${PACKAGES[@]}"
do
  if [ ! -d "/devhome/.atom/packages/$p" ]; then
    gosu $HOSTUSER $APM install $p
  else
    echo "$p already installed."
  fi
done

// fix toolbar-almighty
sed -i "s/icon: 'columns /icon: '/g" /devhome/.atom/packages/tool-bar-almighty/lib/entries.coffee

mkdir -p /devhome/go && cd /devhome/go && mkdir src pkg bin

exec gosu $HOSTUSER bash -c "export PATH=/usr/local/go/bin:/go/bin:$PATH ATOM=$ATOM export LANG=$LANG && dbus-launch /devhome/atom.sh '$@'"
