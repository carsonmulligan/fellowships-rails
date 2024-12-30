class CheckoutController < ApplicationController
  before_action :initialize_stripe

  def create
    # Create a one-time payment session
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'F-RAD Premium Lifetime Access',
            description: 'Get unlimited access to all premium features forever',
          },
          unit_amount: 7900, # $79.00
        },
        quantity: 1,
      }],
      mode: 'payment',
      success_url: "#{root_url}checkout/success",
      cancel_url: "#{root_url}checkout/cancel",
      client_reference_id: session[:user_id],
      allow_promotion_codes: true,
    })

    render json: { id: session.id }
  end

  def success
    # Update user's premium status
    if session[:user_id]
      user = User.find(session[:user_id])
      user.update(premium: true)
      flash[:success] = "Welcome to F-RAD Premium! You now have lifetime access to all features."
    end
    redirect_to root_path
  end

  def cancel
    flash[:notice] = "Your purchase was cancelled. Let us know if you have any questions!"
    redirect_to root_path
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

    if event['type'] == 'checkout.session.completed'
      session = event['data']['object']
      user_id = session.client_reference_id
      
      if user_id
        user = User.find(user_id)
        user.update(premium: true)
      end
    end

    render json: { status: 'success' }
  end

  private

  def initialize_stripe
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  end
end 