# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'darjeelink/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'darjeelink'
  s.version     = Darjeelink::VERSION
  s.authors     = ['James Hulme']
  s.email       = ['james@38degrees.org.uk']
  s.homepage    = 'https://github.com/38degrees/darjeelink'
  s.summary     = 'URL Shortener'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.1.2'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'omniauth', '~> 1.9'
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency 'pg'
  s.add_dependency 'rails', '~> 6'
  s.add_dependency 'rebrandly'
  s.add_dependency 'repost'
  s.add_dependency 'will_paginate'

  # TODO: - MAybe we shoulf have a rubcop config for this instead?
  #
  # rubocop:disable Gemspec/DevelopmentDependencies
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'brakeman'
  s.add_development_dependency 'bundler-audit'
  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  # rubocop:enable Gemspec/DevelopmentDependencies

  # TODO: Remove the above and these dependencies to the Gemfile.
  #
  # group :development, :test do
  #   gem 'awesome_print'
  #   gem 'brakeman'
  #   gem 'bundler-audit'
  #   gem 'dotenv-rails'
  #   gem 'rspec-rails'
  #   gem 'rubocop'
  # end

  s.metadata['rubygems_mfa_required'] = 'true'
end
