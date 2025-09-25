# frozen_string_literal: true

require 'codeword/authentication'
require 'codeword/configuration'

module Codeword
end

# Only load the engine if Rails is present
if defined?(Rails)
  require 'codeword/engine'
end
