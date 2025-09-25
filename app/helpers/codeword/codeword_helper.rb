# frozen_string_literal: true

module Codeword
  module CodewordHelper
    def codeword_hint
      @codeword_hint ||= ENV['CODEWORD_HINT'] || Codeword::Configuration.from_config(:hint)
    end
  end
end
