# frozen_string_literal: true

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

      update!(shortened_path: auto_generate_shortened_path)
    end

    ALPHABET = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ['-', '_']).freeze

    def auto_generate_shortened_path
      # from http://refactormycode.com/codes/125-base-62-encoding
      # with only minor modification
      i = id
      return ALPHABET[0] if i.zero?

      generated_path = []
      base = ALPHABET.length

      while i.positive?
        generated_path << ALPHABET[i.modulo(base)]
        i /= base
      end

      generated_path.join('').reverse
    end
  end
end
