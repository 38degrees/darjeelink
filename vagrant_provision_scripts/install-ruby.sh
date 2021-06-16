#!/usr/bin/env bash
# From https://rvm.io/integration/vagrant
source $HOME/.rvm/scripts/rvm || source /etc/profile.d/rvm.sh

rvm use --default --install 2.7.3

shift

if (( $# ))
  then rvm install 2.7.3
fi

rvm cleanup all
