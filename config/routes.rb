Rails.application.routes.draw do
  root 'scholarships#index'
  
  # Authentication routes
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Resource routes
  resources :scholarships, only: [:index, :show]
  resources :bookmarks, only: [:create, :destroy]
  
  # Pricing and checkout routes
  get '/pricing', to: 'pages#pricing'
  post '/create-checkout-session', to: 'checkout#create'
  get '/checkout/success', to: 'checkout#success'
  get '/checkout/cancel', to: 'checkout#cancel'
  post '/stripe-webhook', to: 'checkout#webhook'
end
