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
