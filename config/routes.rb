Rails.application.routes.draw do
  # Landing page
  root "static_pages#landing"

  # Product page
  get "/product", to: "static_pages#product"

  # Home page (post-subscription or after payment) - now shows scholarships
  get "/home", to: "scholarships#index"

  # Stripe webhook endpoint
  post "/stripe/webhook", to: "stripe#webhook"

  # Create a route to handle "buy" action:
  post "/buy", to: "stripe#buy"

  # OmniAuth callback routes
  get '/auth/:provider/callback', to: 'sessions#omniauth'
  get '/auth/failure', to: redirect('/')

  # Additional scholarship routes if needed
  resources :scholarships, only: [:index]
end
