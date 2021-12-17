module Codeword
  class CodewordController < Codeword::ApplicationController
    CRAWLER_REGEX = /crawl|googlebot|slurp|spider|bingbot|tracker|click|parser|spider/

    if respond_to?(:skip_before_action)
      skip_before_action :check_for_codeword
    else
      skip_before_filter :check_for_codeword
    end

    def unlock
      if params[:codeword].present?
        user_agent = request.env['HTTP_USER_AGENT'].presence
        if user_agent && user_agent.downcase.match(CRAWLER_REGEX)
          head :ok
          return
        end

        @codeword = params[:codeword].to_s.downcase
        @return_to = params[:return_to]
        if @codeword == codeword.to_s.downcase
          set_cookie
          run_redirect
        end
      elsif request.post?
        if params[:codeword].present? && params[:codeword].respond_to?(:'[]')
          @codeword = params[:codeword][:codeword].to_s.downcase
          @return_to = params[:codeword][:return_to]
          if @codeword == codeword.to_s.downcase
            set_cookie
            run_redirect
          else
            @wrong = true
          end
        else
          head :ok
        end
      else
        respond_to :html
      end
    end

    private

    def set_cookie
      cookies[:codeword] = { value: @codeword.to_s.downcase, expires: (Time.now + codeword_cookie_lifetime) }
    end

    def run_redirect
      if @return_to.present?
        redirect_to @return_to.to_s
      else
        redirect_to '/'
      end
    end
  end
end
