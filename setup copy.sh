#!/usr/bin/env bash

###############################################################################
# setup.sh
# ----------------------------------------------------------------------------
# One-step script to scaffold a Ruby on Rails 7.2.2 + Ruby 3.1.2 + PostgreSQL
# + OmniAuth (Google) + Stripe for a single $99 payment flow.
#
# We'll call the project "f-rad" (F-Rad Fellowship).
#
# What it does:
#   1. Creates a new Rails 7.2.2 app with PostgreSQL, Ruby 3.1.2
#   2. Adds gems for:
#       - OmniAuth Google OAuth2 (for user sign-in with Google)
#       - Stripe (for $99 one-time payment)
#   3. Sets up a Payment model + migrations
#   4. Creates placeholders for controllers & routes:
#       - Landing page  (long scroll, CTA)
#       - Product page  (explains plan, triggers Stripe Checkout)
#       - Home page     (post-payment dashboard)
#       - Webhook route (Stripe incoming event)
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
#
###############################################################################

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (1) GET CLI INPUTS FOR CONFIG                                            │
# └────────────────────────────────────────────────────────────────────────────┘
echo "======================================================================"
echo "  Welcome to F-Rad Fellowship Setup (Rails 7.2.2 + Ruby 3.1.2 + Postgres)"
echo "======================================================================"
echo ""

read -p "Enter the project folder name (default 'f-rad'): " APP_NAME
APP_NAME=${APP_NAME:-f-rad}

read -p "Enter your local Postgres DB name (default 'f_rad_dev'): " DB_NAME
DB_NAME=${DB_NAME:-f_rad_dev}

read -p "Enter your local Postgres DB username (default 'postgres'): " DB_USER
DB_USER=${DB_USER:-postgres}

read -p "Enter your local Postgres DB password (leave blank if none): " DB_PASS

echo ""
echo "==== Stripe Info ===="
read -p "Enter your Stripe Publishable Key: " STRIPE_PUBLISHABLE_KEY
read -p "Enter your Stripe Secret Key: " STRIPE_SECRET_KEY
read -p "Enter your Stripe Webhook Signing Secret: " STRIPE_WEBHOOK_SECRET

echo ""
echo "==== Google OAuth Info (OmniAuth) ===="
read -p "Enter your Google Client ID: " GOOGLE_CLIENT_ID
read -p "Enter your Google Client Secret: " GOOGLE_CLIENT_SECRET

echo ""
echo "Proceeding with Rails new..."

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (2) CREATE NEW RAILS 7.2.2 PROJECT                                       │
# └────────────────────────────────────────────────────────────────────────────┘
rails _7.2.2_ new "$APP_NAME" \
  --ruby=3.1.2.2 \
  --database=postgresql

cd "$APP_NAME" || { echo "Failed to cd into $APP_NAME"; exit 1; }

# Update config/database.yml with given DB credentials
# We'll do a simple sed-based approach.
cat <<EOF > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  host: localhost
  username: $DB_USER
  password: $DB_PASS
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: $DB_NAME

test:
  <<: *default
  database: ${DB_NAME}_test

production:
  <<: *default
  database: ${DB_NAME}_prod
  username: $DB_USER
  password: $DB_PASS
EOF

echo "Updating Gemfile with OmniAuth Google, Stripe, and dotenv-rails..."

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (3) ADD GEMS: DOTENV, OMNIAUTH-GOOGLE-OAUTH2, STRIPE                     │
# └────────────────────────────────────────────────────────────────────────────┘
cat <<EOF >> Gemfile

# For environment variables
gem 'dotenv-rails', groups: [:development, :test]

# For Google OAuth
gem 'omniauth-google-oauth2'

# For Stripe integration
gem 'stripe'
EOF

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (4) BUNDLE INSTALL                                                       │
# └────────────────────────────────────────────────────────────────────────────┘
bundle install

echo "Creating .env file with Stripe + Google credentials..."

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (5) CREATE .env                                                          │
# └────────────────────────────────────────────────────────────────────────────┘
cat <<EOF > .env
# Stripe
STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY=$STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET=$STRIPE_WEBHOOK_SECRET

# Google OAuth
GOOGLE_CLIENT_ID=$GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET=$GOOGLE_CLIENT_SECRET

# Possibly we store secret keys here
EOF

# Add .env to .gitignore
echo ".env" >> .gitignore


# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (6) RUN RAILS DB CREATE + MIGRATE                                        │
# └────────────────────────────────────────────────────────────────────────────┘
echo "Setting up database..."
rails db:create

echo "Generating Payment model..."
# We'll store a single Payment record for each user who paid
rails generate model Payment user_id:string amount:integer currency:string status:string created_at:datetime

# Modify the generated migration to set default timestamps if needed
# We'll rely on rails default. Then rake db:migrate
rails db:migrate

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (7) CREATE A CONTROLLER + ROUTES FOR LANDING, PRODUCT, HOME, WEBHOOK     │
# └────────────────────────────────────────────────────────────────────────────┘
echo "Generating controllers (StaticPages: landing, product, home) + StripeWebhook..."

rails generate controller static_pages landing product home
rails generate controller stripe webhook --no-helper --no-assets

# Now let's add some routes in config/routes.rb
cat <<'EOF' > config/routes.rb
Rails.application.routes.draw do
  # Landing page
  root "static_pages#landing"

  # Product page
  get "/product", to: "static_pages#product"

  # Home page (post-subscription or after payment)
  get "/home", to: "static_pages#home"

  # Stripe webhook endpoint
  post "/stripe/webhook", to: "stripe#webhook"
end
EOF

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (8) IMPLEMENT STATIC_PAGES CONTROLLER METHODS                            │
# └────────────────────────────────────────────────────────────────────────────┘
cat <<'EOF' > app/controllers/static_pages_controller.rb
class StaticPagesController < ApplicationController
  require 'stripe'

  # Show a long scroll landing page with multiple CTAs
  def landing
  end

  # Show "Explore / Prepare / Execute" modules with "Buy $99" CTA
  def product
  end

  # Show a "Home" page if user has paid or is recognized (we'll do a simple check)
  def home
    # Suppose we check Payment table for "status='succeeded'" with user_id from session
    if !session[:user_id]
      redirect_to root_path, notice: "Please sign in first"
      return
    end

    @payments = Payment.where(user_id: session[:user_id], status: 'succeeded')
    if @payments.empty?
      redirect_to product_path, alert: "You haven't paid yet"
    end
  end

end
EOF

# We'll just create minimal HTML views for them
mkdir -p app/views/static_pages
cat <<'EOF' > app/views/static_pages/landing.html.erb
<h1>F-Rad Fellowship Planner</h1>
<p>Welcome to F-Rad. Win major grad fellowships like Rhodes, etc. Long Scroll, multiple CTAs.</p>
<p><a href="/auth/google_oauth2">Sign in with Google</a> | <a href="/product">Buy $99</a></p>
EOF

cat <<'EOF' > app/views/static_pages/product.html.erb
<h1>F-Rad Product Page</h1>
<p>Explore / Prepare / Execute modules. Payment => $99 One-time.</p>

<%= form_with url: buy_path, local: true do %>
  <button type="submit">Buy $99</button>
<% end %>

EOF

cat <<'EOF' > app/views/static_pages/home.html.erb
<h1>F-Rad Home (Dashboard)</h1>
<p>Congrats, you're recognized as paid or logged in. Access your fellowship tips here.</p>
<ul>
  <li>Rhodes Scholarship</li>
  <li>Marshall Scholarship</li>
  <li>Gates-Cambridge Scholarship</li>
  <li>Churchill Scholarship</li>
</ul>
EOF

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (9) ADD STRIPE CONTROLLER (webhook, create-checkout, etc.)               │
# └────────────────────────────────────────────────────────────────────────────┘
cat <<'EOF' > app/controllers/stripe_controller.rb
class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  require 'stripe'
  require 'dotenv/load'  # So we can read STRIPE_SECRET_KEY, etc.

  # For local usage, we can create "buy" action that sets up a Stripe Checkout
  def buy
    # Must have user_id in session
    unless session[:user_id]
      return redirect_to "/auth/google_oauth2", notice: "Please sign in first"
    end

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    checkout_session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: { name: 'F-Rad Fellowship Access' },
          unit_amount: 9900,
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: root_url + "home?status=success",
      cancel_url: root_url + "product?status=cancelled",
      metadata: {
        # We'll store user_id from session
        user_id: session[:user_id]
      }
    )

    redirect_to checkout_session.url, allow_other_host: true
  end

  # The webhook that Stripe calls after successful payment
  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    event = nil
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      return render json: { error: e }, status: 400
    rescue Stripe::SignatureVerificationError => e
      return render json: { error: e }, status: 400
    end

    if event['type'] == 'checkout.session.completed'
      session_object = event['data']['object']
      user_id = session_object['metadata']['user_id']
      payment_status = session_object['payment_status']

      if user_id && payment_status == 'paid'
        Payment.create!(
          user_id: user_id,
          amount: 9900,
          currency: 'usd',
          status: 'succeeded'
        )
      end
    end

    render json: { received: true }, status: 200
  end

end
EOF

# We also need a route for 'buy'. We'll add that route in routes.rb
cat <<'EOF' >> config/routes.rb

# Create a route to handle "buy" action:
post "/buy", to: "stripe#buy"
EOF

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (10) OMNIAUTH GOOGLE SETUP                                               │
# └────────────────────────────────────────────────────────────────────────────┘
echo "Adding OmniAuth config to config/initializers/omniauth.rb"
mkdir -p config/initializers

cat <<'EOF' > config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email,profile',
      prompt: 'select_account',
    }
end

# We'll also define some callback routes in routes.rb
EOF

cat <<'EOF' >> config/routes.rb

# OmniAuth callback routes
get '/auth/:provider/callback', to: 'sessions#omniauth'
get '/auth/failure', to: redirect('/')
EOF

echo "Generating sessions controller for OmniAuth callback..."
rails generate controller sessions omniauth --no-helper --no-assets

cat <<'EOF' > app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def omniauth
    # Retrieve the google info from request.env['omniauth.auth']
    auth = request.env['omniauth.auth']

    # For simplicity, we'll store user_id in session as the email
    email = auth.info.email

    session[:user_id] = email
    redirect_to root_path, notice: "Signed in as #{email}"
  end
end
EOF

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (11) ASCII WIREFRAME (Ruby on Rails version)                             │
# └────────────────────────────────────────────────────────────────────────────┘
# We'll just echo it:

cat <<'ASCII' >> README.md

ASCII Wireframe for F-Rad (Ruby on Rails):
------------------------------------------
Landing Page (/) => sign in or buy => /product => create checkout => Stripe => 
webhook => Payment => /home => see content.

   LANDING PAGE:
   ┌────────────────────────────────────────────────────────────────┐
   │ F-Rad Fellowship Planner (multiple CTAs)                      │
   │   [Sign In w/ Google]  [Buy $99 => post /buy]                 │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   PRODUCT PAGE (/product):
   ┌────────────────────────────────────────────────────────────────┐
   │ Modules: Explore, Prepare, Execute                            │
   │   - "Buy $99" => post /buy => Stripe checkout                 │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   STRIPE WEBHOOK (/stripe/webhook):
   ┌────────────────────────────────────────────────────────────────┐
   │ If event= checkout.session.completed => Payment.create(...)    │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   HOME PAGE (/home):
   ┌────────────────────────────────────────────────────────────────┐
   │ If Payment found => show advanced content, else redirect.      │
   └────────────────────────────────────────────────────────────────┘

Usage:
1) rails s
2) visit http://localhost:3000
3) Create "payments" table already done by generator + migrations.
4) Google OAuth => /auth/google_oauth2
5) Happy hacking!

ASCII

# ┌────────────────────────────────────────────────────────────────────────────┐
# │ (12) MIGRATE & WRAP UP                                                  │
# └────────────────────────────────────────────────────────────────────────────┘
echo "Final db:migrate if needed..."
rails db:migrate

echo "--------------------------------------------------------------------"
echo "Setup complete for Ruby on Rails (F-Rad) w/ local Postgres, OmniAuth Google, Stripe."
echo ""
echo "Next steps:"
echo "1) cd $APP_NAME"
echo "2) rails server"
echo "3) Go to http://localhost:3000"
echo "   - Landing page (root => static_pages#landing)"
echo "   - Product page => /product"
echo "   - Stripe route => /buy => triggers checkout"
echo "   - Stripe webhook => /stripe/webhook"
echo "   - OmniAuth callback => /auth/google_oauth2/callback"
echo ""
echo "Be sure to confirm 'payments' table creation and that your DB is running."
echo "Add any advanced logic as needed. Enjoy your new F-Rad app!"
echo "--------------------------------------------------------------------"
