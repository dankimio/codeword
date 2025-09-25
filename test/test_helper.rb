ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rails/test_help'

# Load support files
Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each { |f| require f }

class ActionDispatch::IntegrationTest
  def follow_redirects!(limit: 5)
    limit.times do
      break unless response.redirect?
      follow_redirect!
    end
  end
end
