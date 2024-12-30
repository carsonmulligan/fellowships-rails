Rails.application.routes.draw do
  root 'scholarships#index'
  
  resources :scholarships, only: [:index]
  resources :bookmarks, only: [:index, :create, :destroy]
  
  # Authentication routes
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
  delete '/logout', to: 'sessions#destroy'
  
  # Checkout routes
  post '/create-checkout-session', to: 'checkout#create'
  get '/checkout/success', to: 'checkout#success'
  get '/checkout/cancel', to: 'checkout#cancel'
  post '/stripe-webhook', to: 'checkout#webhook'
end
