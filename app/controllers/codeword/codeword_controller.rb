module Codeword
  class CodewordController < Codeword::ApplicationController
    CRAWLER_REGEX = /crawl|googlebot|slurp|spider|bingbot|tracker|parser/

    skip_before_action :require_codeword!, raise: false

    def unlock
      user_agent = request.env["HTTP_USER_AGENT"].presence
      if user_agent&.downcase&.match(CRAWLER_REGEX)
        head :ok
        return
      end

      if params[:codeword].present?
        @codeword = params[:codeword].to_s.downcase
        @return_to = params[:return_to]
        if @codeword == Codeword::Configuration.codeword_code.to_s.downcase
          set_cookie
          run_redirect
        else
          @wrong = true
        end
      else
        respond_to :html
      end
    end

    private

    def set_cookie
      cookies[:codeword] = {
        value: @codeword.to_s.downcase,
        expires: Codeword::Configuration.codeword_cookie_lifetime.from_now,
        httponly: true,
        secure: request.ssl?,
        same_site: :lax
      }
    end

    def run_redirect
      if @return_to.present?
        redirect_to @return_to.to_s, allow_other_host: false
      else
        redirect_to "/"
      end
    rescue ActionController::Redirecting::UnsafeRedirectError
      redirect_to "/"
    end
  end
end
