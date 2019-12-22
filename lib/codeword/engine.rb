module Codeword
  class Engine < ::Rails::Engine
    isolate_namespace Codeword

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.assets false
      g.helper false
    end

    initializer 'codeword.app_controller' do |_app|
      ActiveSupport.on_load(:action_controller) { include Codeword }
    end
  end
end
