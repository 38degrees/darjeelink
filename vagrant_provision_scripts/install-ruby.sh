#!/usr/bin/env bash
# From https://rvm.io/integration/vagrant
source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh

rvm use --default --install $1

shift

if (( $# ))
  then rvm install $@
fi

rvm cleanup all
