class ApplicationController < ActionController::Base
  include Codeword::Authentication

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_codeword!

  def render_404
    render file: Rails.root.join('public', '404.html'), status: 404
  end
end
