# frozen_string_literal: true

require 'codeword/engine'

module Codeword
  extend ActiveSupport::Concern

  def self.from_config(setting)
    store = Rails.application.credentials

    store.codeword.respond_to?(:fetch) &&
      store.codeword.fetch(setting, store.public_send("codeword_#{setting}")) ||
      store.public_send("codeword_#{setting}") || store.public_send(setting)
  end

  private

  def require_codeword!
    return unless respond_to?(:codeword) && codeword_code
    return if cookies[:codeword].present? && cookies[:codeword] == codeword_code.to_s.downcase

    redirect_to codeword.unlock_path(
      return_to: request.fullpath.split('?codeword')[0],
      codeword: params[:codeword]
    )
  end

  alias_method :check_for_codeword, :require_codeword!

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
