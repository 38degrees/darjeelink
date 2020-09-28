# frozen_string_literal: true

module Darjeelink
  class Configuration
    attr_accessor :domain, :source_mediums, :auth_domain, :rebrandly_api_key, :fallback_url

    def initialize
      @domain = nil
      @source_mediums = nil
      @auth_domain = nil
      @rebrandly_api_key = nil
      @fallback_url = nil
    end
  end
end
