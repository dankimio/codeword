Rails.application.routes.draw do
  mount Codeword::Engine, at: '/codeword', as: 'codeword'

  resources :posts, only: %i[index show]

  # this makes tests fail with endless redirect loop b/c it is before codeword routes
  # catch all route b/c Rails `rescue_from` doesn't catch ActionController::RoutingError
  match '*path', via: :all, to: 'application#render_404'
end
