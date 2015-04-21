#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

## Install Puppet

if ! [ -x "$(command -v facter)" ]; then
    echo "Installing facter..."
    curl http://downloads.puppetlabs.com/mac/facter-latest.dmg -o /tmp/facter-latest.dmg
    hdiutil attach /tmp/facter-latest.dmg
    sudo installer -pkg /Volumes/facter-*/facter-*.pkg -target /
    hdiutil detach /Volumes/facter-*
fi

if ! [ -x "$(command -v hiera)" ]; then
    echo "Installing hiera..."
    curl http://downloads.puppetlabs.com/mac/hiera-latest.dmg -o /tmp/hiera-latest.dmg
    hdiutil attach /tmp/hiera-latest.dmg
    sudo installer -pkg /Volumes/hiera-*/hiera-*.pkg -target /
    hdiutil detach /Volumes/hiera-*
fi

if ! [ -x "$(command -v puppet)" ]; then
    echo "Installing puppet..."
    curl http://downloads.puppetlabs.com/mac/puppet-latest.dmg -o /tmp/puppet-latest.dmg
    hdiutil attach /tmp/puppet-latest.dmg
    sudo installer -pkg /Volumes/puppet-*/puppet-*.pkg -target /
    hdiutil detach /Volumes/puppet-*
fi


## Get Config
if [ -d "$DIR/puppet" ]; then
    ENVDIR="$DIR"
elif [ -d "/tmp/env" ]; then
    echo "Updating config..."
    git pull origin master /tmp/env
    ENVDIR="/tmp/env"
else
    echo "Fetching config..."
    mkdir /tmp/env
    git clone https://github.com/tylermenezes/env.git /tmp/env
    ENVDIR="/tmp/env"
fi



## Install a few other things we need for puppet

if ! [ $(xcode-select -p) ]; then
    sudo xcode-select --install
fi



## Apply Config

echo "Applying config..."
USERNAME=$(whoami)
sudo FACTER_username=$USERNAME puppet apply --verbose --modulepath="$ENVDIR/puppet/modules" "$ENVDIR/puppet/manifests/init.pp"