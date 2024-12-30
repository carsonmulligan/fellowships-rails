class CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def create
    # Store the email in the session for later use
    session[:checkout_email] = params[:email]

    # Create a Stripe checkout session
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price: params[:price],
        quantity: 1,
      }],
      mode: 'payment',
      success_url: success_url,
      cancel_url: cancel_url,
      customer_email: params[:email],
      metadata: {
        email: params[:email]
      }
    })

    render json: { url: session.url }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def success
    # The user has completed payment
    email = session[:checkout_email]
    
    # If the user is not signed in, create a new user account
    unless current_user
      password = Devise.friendly_token[0, 20]
      user = User.create!(
        email: email,
        password: password,
        password_confirmation: password
      )
      sign_in(user)
    end

    # Update user's premium status
    current_user.update(premium: true)
    
    # Clear the checkout email from session
    session.delete(:checkout_email)
    
    redirect_to root_path, notice: 'Welcome to Fellows! Your payment was successful.'
  end

  def cancel
    redirect_to root_path, alert: 'Payment was cancelled.'
  end

  def webhook
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      status 400
      return
    end

    case event.type
    when 'checkout.session.completed'
      session = event.data.object
      email = session.metadata.email
      
      # Find or create user
      user = User.find_by(email: email)
      if user
        user.update(premium: true)
      else
        password = Devise.friendly_token[0, 20]
        User.create!(
          email: email,
          password: password,
          password_confirmation: password,
          premium: true
        )
      end
    end

    render json: { message: 'Success' }
  end

  private

  def success_url
    checkout_success_url
  end

  def cancel_url
    checkout_cancel_url
  end
end 