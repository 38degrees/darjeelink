# frozen_string_literal: true

module Darjeelink
  class TrackingLinksController < Darjeelink::ApplicationController
    def new
      @short_link = Darjeelink::ShortLink.new
    end
  end
end
