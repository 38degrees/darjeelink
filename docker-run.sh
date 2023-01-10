#/bin/sh -
# Intended to be run within docker
cd app 
cp -f env.docker.test.sample spec/dummy/.env.test 
cp -f env.docker.development.sample spec/dummy/.env.development

bundle config set --local path /bundle/ && bundle check || bundle install && bundle exec rails db:setup && bundle exec rails db:setup RAILS_ENV=test && bundle exec rspec
