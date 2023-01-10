# frozen_string_literal: true
require 'securerandom'

module Darjeelink
  class ShortLink < ApplicationRecord
    after_save :generate_short_link

    validates_presence_of :url
    validates :url, :shortened_path, format: {
      without: /\s/,
      message: 'must not contain any whitespace (spaces, tabs, etc)'
    }

    class << self
      def search(query)
        where(
          'shortened_path ILIKE :query', query: "%#{query}%"
        ).or(
          where(
            'url ILIKE :query', query: "%#{query}%"
          )
        )
      end

      def ifind(shortened_path)
        where('lower(shortened_path) = ?', shortened_path.downcase).first
      end
    end

    private

    def generate_short_link
      return if shortened_path.present?

      begin
        update!(shortened_path: auto_generate_shortened_path)
      rescue ActiveRecord::RecordNotUnique
         # we want to keep on trying till we get a non conflicting version
        retry
      end
    end

    def auto_generate_shortened_path
      # our current db has a case insensitive constraint so we might as well downcase here before we get to db level
      SecureRandom.urlsafe_base64(3).downcase
    end
  end
end
