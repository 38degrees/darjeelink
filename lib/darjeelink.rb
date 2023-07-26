# frozen_string_literal: true

require 'rebrandly'

require 'will_paginate'
require 'will_paginate/active_record'

require 'omniauth'
require 'omniauth-google-oauth2'

require 'darjeelink/engine'
require 'darjeelink/configuration'

module Darjeelink
  class << self
    delegate :domain, to: :configuration
    delegate :source_mediums, to: :configuration
    delegate :auth_domain, to: :configuration
    delegate :rebrandly_api_key, to: :configuration
    delegate :fallback_url, to: :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
