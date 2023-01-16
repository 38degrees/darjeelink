# frozen_string_literal: true

require 'securerandom'

module Darjeelink
  class ShortLink < ApplicationRecord
    # ActiveRecord::RecordNotUnique error unable to be raised in a transaction that is not committed so this was changed to after_commit
    after_commit :generate_short_link

    def self.auto_generate_shortened_path
      # our current db has a case insensitive constraint so we might as well downcase here before we get to db level
      pp SecureRandom.urlsafe_base64(3).downcase
    end

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
        attempt ||= 0
        update!(shortened_path: self.class.auto_generate_shortened_path)
      rescue ActiveRecord::RecordNotUnique
        # we only want to try 5 times to prevent infinite loop
        attempt += 1
        raise unless attempt <= 5
      end
    end
  end
end
