# frozen_string_literal: true

module Darjeelink
  class Configuration
    attr_accessor :domain
    attr_accessor :source_mediums
    attr_accessor :auth_domain
    attr_accessor :rebrandly_api_key
    attr_accessor :fallback_url

    def initialize
      @domain = nil
      @source_mediums = nil
      @auth_domain = nil
      @rebrandly_api_key = nil
      @fallback_url = nil
    end
  end
end
