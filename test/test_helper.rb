ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rails/test_help'

class ActionDispatch::IntegrationTest
  def follow_redirects!(limit: 5)
    limit.times do
      break unless response.redirect?
      follow_redirect!
    end
  end

  def reset_codeword_configuration_cache!
    Codeword::Configuration.instance_variable_set(:"@cookie_lifetime", nil)
    Codeword::Configuration.instance_variable_set(:"@codeword_code", nil)
  end
end
