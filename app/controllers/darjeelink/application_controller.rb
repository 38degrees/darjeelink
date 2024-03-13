# frozen_string_literal: true

module Darjeelink
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :check_ip_whitelist
    before_action :authenticate

    private

    # Disabling these rubocop rules. This is a simple function and tested in production sinve version 0.14.4.
    #
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Layout/LineLength
    # Check user IP address against whitelist from ENV
    def check_ip_whitelist
      return unless Rails.env.production?
      return unless Rails.application.config.permitted_ips
      ip_to_verify = if Rails.application.config.respond_to?(:client_ip_header) && Rails.application.config.client_ip_header.present?
          request.headers[Rails.application.config.client_ip_header]
        else
          request.ip
        end

      return if Rails.application.config.permitted_ips.split(',').include? ip_to_verify

      render plain: 'Access Denied', status: :forbidden
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Layout/LineLength

    # Authenticate against Google OAuth
    def authenticate
      return if session[:email] || request.path =~ /google_oauth2/ || Rails.env.test?
      # Seperate line to make it easier to disable the bypass if doing some auth
      # related locally
      return if Rails.env.development?

      redirect_post '/auth/google_oauth2'
    end
  end
end
