module Codeword
  class Engine < ::Rails::Engine
    isolate_namespace Codeword

    initializer 'codeword.app_controller' do |_app|
      ActiveSupport.on_load(:action_controller) { include Codeword }
    end
  end
end
