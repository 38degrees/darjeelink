# frozen_string_literal: true

module Darjeelink
  class ApiController < Darjeelink::ApplicationController
    skip_before_action :check_ip_whitelist
    skip_before_action :authenticate
    skip_before_action :verify_authenticity_token

    before_action :authenticate_token

    def create
      short_link = Darjeelink::ShortLink.create!(short_link_params)

      render(
        json: { short_link: "#{Darjeelink.domain}/#{short_link.shortened_path}" },
        status: :created
      )
    rescue ActiveRecord::RecordNotUnique
      render(
        json: { error: "#{short_link_params[:shortened_path]} already used! Choose a different custom path" },
        status: :bad_request
      )
      else
        render(
          json: { error: "#{short_link_params[:shortened_path]} already used! Choose a different custom path" },
          status: :bad_request
        )
      end
    rescue ActiveRecord::RecordInvalid => e
      render(
        json: { error: e.message.to_s },
        status: :bad_request
      )
    rescue ActionController::ParameterMissing
      render(
        json: { error: 'Missing required params' },
        status: :bad_request
      )
    end

    private

    def short_link_params
      params.require(:short_link).permit(:url, :shortened_path)
    end

    def authenticate_token
      # The Authorization header must be supplied in the following format:
      # "Authorization" => "Token token=#{username}:#{token}"
      authenticate_or_request_with_http_token do |username_token, _options|
        # Perform token comparison; avoid timing attacks and length leaks
        # See: https://thisdata.com/blog/timing-attacks-against-string-comparison/
        return head(:unauthorized) unless valid_authorization_token?(username_token)

        return true
      end
    end

    def valid_authorization_token?(username_token)
      username, token = username_token.split ':'

      stored_token = ApiToken.find_by(username: username, active: true)&.token
      return false if stored_token.nil?

      ActiveSupport::SecurityUtils.secure_compare(
        token,
        stored_token
      )
    end
  end
end
