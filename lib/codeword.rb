# frozen_string_literal: true

require 'codeword/engine'
require 'codeword/authentication'

module Codeword
  extend ActiveSupport::Concern

  def self.from_config(setting)
    store = Rails.application.credentials

    store.codeword.respond_to?(:fetch) &&
      store.codeword.fetch(setting, store.public_send("codeword_#{setting}")) ||
      store.public_send("codeword_#{setting}") || store.public_send(setting)
  end

  def cookie_lifetime
    @cookie_lifetime ||=
      ENV['COOKIE_LIFETIME_IN_WEEKS'] ||
      ENV['cookie_lifetime_in_weeks'] ||
      Codeword.from_config(:cookie_lifetime_in_weeks)
  end

  def codeword_code
    @codeword_code ||= ENV['CODEWORD'] || ENV['codeword'] || Codeword.from_config(:codeword)
  end

  def codeword_cookie_lifetime
    seconds = (cookie_lifetime.to_f * 1.week).to_i
    if seconds.positive?
      seconds
    else
      5.years
    end
  end
end
