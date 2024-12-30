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
  post '/webhook', to: 'checkout#webhook'

  # Account setup routes
  get '/account/setup', to: 'accounts#setup', as: 'account_setup'
  post '/account/create_password', to: 'accounts#create_password', as: 'create_password_account'
end


