#!/bin/sh

# This is a simple command to run a shell within the docker container containing the correct 
# tooling to perform simple development operation on this reposiority, e.g. : 
# 
# bundle install
# bundle exec rspec
# bundle exec rails db:setup RAILS_ENV=test

# docker run -it --rm -v "${PWD}:/app" -w /app ruby:3.1.0 bash
docker run -it --rm -v "${PWD}:/app" -w /app ruby:3.1.3 bash