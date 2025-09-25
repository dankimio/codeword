# frozen_string_literal: true

module Codeword
  module Configuration
    def self.from_config(setting)
      store = Rails.application.credentials

      store.codeword.respond_to?(:fetch) &&
        store.codeword.fetch(setting, store.public_send("codeword_#{setting}")) ||
        store.public_send("codeword_#{setting}") || store.public_send(setting)
    end

    def self.cookie_lifetime
      @cookie_lifetime ||=
        ENV['COOKIE_LIFETIME_IN_WEEKS'] ||
        from_config(:cookie_lifetime_in_weeks)
    end

    def self.codeword_code
      @codeword_code ||= ENV['CODEWORD'] || from_config(:codeword)
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
