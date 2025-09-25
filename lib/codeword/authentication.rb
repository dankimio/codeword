module Codeword
  module Authentication
    extend ActiveSupport::Concern

    def require_codeword!
      return unless respond_to?(:codeword) && Codeword::Configuration.codeword_code
      return if cookies[:codeword].present? && cookies[:codeword] == Codeword::Configuration.codeword_code.to_s.downcase

      redirect_to codeword.unlock_path(
        return_to: request.fullpath.split('?codeword')[0],
        codeword: params[:codeword]
      )
    end

    alias_method :check_for_codeword, :require_codeword!
  end
end
