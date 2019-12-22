# frozen_string_literal: true

require 'codeword/engine'

module Codeword
  extend ActiveSupport::Concern

  included do
    if respond_to?(:before_action)
      before_action :check_for_codeword, except: ['unlock']
    else
      before_filter :check_for_codeword, except: ['unlock']
    end
  end

  def self.from_config(setting, secrets_or_credentials = :credentials)
    return unless Rails.application.respond_to?(secrets_or_credentials)

    store = Rails.application.public_send(secrets_or_credentials)

    store.codeword.respond_to?(:fetch) &&
      store.codeword.fetch(setting, store.public_send("codeword_#{setting}")) ||
      store.public_send("codeword_#{setting}") || store.public_send(setting)
  end

  private

  def check_for_codeword
    return unless respond_to?(:codeword) && codeword_code
    return if cookies[:codeword].present? && cookies[:codeword] == codeword_code.to_s.downcase

    redirect_to codeword.unlock_path(
      return_to: request.fullpath.split('?codeword')[0],
      codeword: params[:codeword]
    )
  end

  def cookie_lifetime
    @cookie_lifetime ||=
      ENV['COOKIE_LIFETIME_IN_WEEKS'] ||
      ENV['cookie_lifetime_in_weeks'] ||
      Codeword.from_config(:cookie_lifetime_in_weeks, :secrets) ||
      Codeword.from_config(:cookie_lifetime_in_weeks)
  end

  def codeword_code
    @codeword ||=
      ENV['CODEWORD'] ||
      ENV['codeword'] ||
      Codeword.from_config(:codeword, :secrets) ||
      Codeword.from_config(:codeword)
  end

  def codeword_cookie_lifetime
    seconds = (cookie_lifetime.to_f * 1.week).to_i
    if seconds > 0
      seconds
    else
      5.years
    end
  end
end
