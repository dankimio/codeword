# frozen_string_literal: true

module CodewordTestHelper
  def reset_codeword_configuration_cache!
    Codeword::Configuration.instance_variable_set(:"@cookie_lifetime", nil)
    Codeword::Configuration.instance_variable_set(:"@codeword_code", nil)
  end
end


