# frozen_string_literal: true

module Darjeelink
  class SessionsController < Darjeelink::ApplicationController
    def create
      if auth_domain.present? && auth_domain == Darjeelink.auth_domain
        update_session
        redirect_to '/'
      else
        render plain: 'Access Denied', status: :forbidden
      end
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end

    def auth_domain
      auth_hash['info']['email'].split('@')[1] if auth_hash
    end

    private

    def update_session
      session[:email] = auth_hash['info']['email']
      session[:name]  = auth_hash['info']['name']
    end
  end
end
