# frozen_string_literal: true

module Darjeelink
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :check_ip_whitelist
    before_action :authenticate

    private

    # Check user IP address against whitelist from ENV
    def check_ip_whitelist
      return unless Rails.env.production?
      return unless Rails.application.config.permitted_ips
      return if Rails.application.config.permitted_ips.split(',').include? request.ip

      render plain: 'Access Denied', status: :forbidden
    end

    # Authenticate against Google OAuth
    def authenticate
      return if session[:email] || request.path =~ /google_oauth2/ || Rails.env.test?
      # Seperate line to make it easier to disable the bypass if doing some auth
      # related locally
      return if Rails.env.development?
      
      Rails.logger.info "Session authenticity_token: #{session[:_csrf_token]}"
      Rails.logger.info "form_authenticity_token: #{form_authenticity_token}"

      redirect_post('/auth/google_oauth2', params: { form_authenticity_token: form_authenticity_token })
    end
  end
end
