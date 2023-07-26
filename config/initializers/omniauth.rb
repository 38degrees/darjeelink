# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :google_oauth2,
    ENV['GOOGLE_API_CLIENT_ID'],
    ENV['GOOGLE_API_CLIENT_SECRET']
  )
end
OmniAuth.config.allowed_request_methods = [:post]
