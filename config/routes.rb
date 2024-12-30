Rails.application.routes.draw do
  # Devise routes with OmniAuth
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }
  devise_for :admins
  
  # Root route
  root 'scholarships#index'
  
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
