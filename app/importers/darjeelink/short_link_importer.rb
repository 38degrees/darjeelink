# frozen_string_literal: true

module Darjeelink
  class ShortLinkImporter
    def initialize(path_to_csv)
      @path_to_csv = path_to_csv
      @duplicates = []
    end

    def import
      CSV.foreach(path_to_csv, headers: true).each do |row|
        url, auto_generated_key, custom_key = row.fields
        create_short_link(url, auto_generated_key, custom_key)
      end

      duplicate_string = duplicates.join("\n")
      Rails.logger.warn("Duplicates:\n#{duplicate_string}") unless duplicates.empty?
    end

    private

    attr_reader :path_to_csv
    attr_accessor :duplicates

    def create_short_link(url, auto_generated_key, custom_key)
      shortened_path = custom_key.present? ? custom_key : auto_generated_key
      ::Darjeelink::ShortLink.create!(url:, shortened_path:)
    rescue ActiveRecord::RecordNotUnique
      duplicates << "#{url}/#{custom_key || auto_generated_key}"
    end
  end
end
