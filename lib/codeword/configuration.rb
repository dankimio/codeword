# frozen_string_literal: true

module Codeword
  module Configuration
    def self.from_credentials(setting)
      store = Rails.application.credentials

      store.dig(:codeword, setting)
    end

    def self.cookie_lifetime
      @cookie_lifetime ||=
        ENV['COOKIE_LIFETIME_IN_WEEKS'] ||
        from_credentials(:cookie_lifetime_in_weeks)
    end

    def self.codeword_code
      @codeword_code ||= ENV['CODEWORD'] || from_credentials(:codeword)
    end

    def self.codeword_cookie_lifetime
      weeks = cookie_lifetime.to_f
      if weeks.positive?
        weeks.weeks
      else
        5.years
      end
    end
  end
end
