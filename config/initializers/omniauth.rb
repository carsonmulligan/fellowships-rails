Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {
    scope: 'email,profile',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50,
    access_type: 'online'
  }
end

# Ensure OmniAuth only accepts POST requests for security
OmniAuth.config.allowed_request_methods = [:post]

# Enable CSRF protection
OmniAuth.config.allowed_request_methods = %i[post]
OmniAuth.config.silence_get_warning = true

# We'll also define some callback routes in routes.rb
