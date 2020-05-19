#!/usr/bin/env bash

echo "************************************************************"
echo "*****  Installing bundler                              *****"
echo "************************************************************"

cd /vagrant
gem install bundler --no-document

echo "************************************************************"
echo "*****  Installing      gems                            *****"
echo "************************************************************"

cd /vagrant
bundle install

echo "************************************************************"
echo "*****  Creating the darjeelink_dbuser role               *****"
echo "************************************************************"

sudo -u postgres psql -c "drop role if exists darjeelink_dbuser; create role darjeelink_dbuser with SUPERUSER login password 'password'"

echo "************************************************************"
echo "*****  Setting up the development database             *****"
echo "************************************************************"

cd /vagrant
bundle exec rails db:setup

echo "************************************************************"
echo "*****  Setting up the test database                    *****"
echo "************************************************************"

cd /vagrant
bundle exec rails db:setup RAILS_ENV=test

echo "************************************************************"
echo "*****  Exporting variables                             *****"
echo "************************************************************"
echo "cd /vagrant" >> ~/.profile
