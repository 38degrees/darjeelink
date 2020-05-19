#!/usr/bin/env bash

# Install packages required by bundler and gems
sudo apt-get install -y git libxml2-dev

# Install PostgreSQL
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-11 libpq-dev
