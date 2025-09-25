require File.expand_path("boot", __dir__)

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_model"

Bundler.require(*Rails.groups)
require "codeword"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
  end
end
