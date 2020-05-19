# frozen_string_literal: true

module Darjeelink
  class RebrandlyImporter
    def initialize
      @duplicates = []
      @api = Rebrandly::Api.new
    end

    def import
      import_rebrandly_links

      Rails.logger.info("Imported #{api.link_count - duplicates.count} links from Rebrandly")
      duplicate_string = duplicates.join("\n")
      Rails.logger.warn("Duplicates:\n#{duplicate_string}") unless duplicates.empty?
    end

    private

    attr_reader :api
    attr_accessor :duplicates

    def import_rebrandly_links
      last_id = nil
      imported_count = 0

      while imported_count < api.link_count
        api.links(last: last_id).each do |link|
          begin
            create_short_link(link)
            last_id = link.id
          rescue ActiveRecord::RecordNotUnique
            duplicates << "#{link.destination}/#{link.slashtag}"
          end
          imported_count += 1
        end
      end
    end

    def create_short_link(link)
      Darjeelink::ShortLink.create!(
        url: link.destination,
        shortened_path: link.slashtag,
        visits: link.clicks
      )
    end
  end
end
