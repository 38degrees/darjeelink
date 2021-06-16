# frozen_string_literal: true

module Darjeelink
  class ApiToken < ApplicationRecord
    validates :username, uniqueness: true
    validates :token, length: { minimum: 32 }, uniqueness: true

    before_validation :generate_token

    def generate_token
      self.token = SecureRandom.uuid if token.blank?
    end
  end
end
