class CheckoutController < ApplicationController
  def create
    # Create a new Stripe checkout session
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: 'Premium Scholarship Access',
            description: 'Bookmark scholarships, track applications, and get notifications',
          },
          unit_amount: 999, # $9.99 in cents
          recurring: {
            interval: 'month'
          }
        },
        quantity: 1,
      }],
      mode: 'subscription',
      success_url: success_url,
      cancel_url: cancel_url,
    })

    render json: { id: session.id }
  end

  def success
    # Handle successful subscription
    # This is where we'll create/update the user's premium status
    if session[:user_id]
      user = User.find(session[:user_id])
      user.update(premium: true)
      flash[:notice] = "Thank you for subscribing! You now have access to premium features."
    end
    redirect_to root_path
  end

  def cancel
    flash[:alert] = "Your subscription was not completed."
    redirect_to root_path
  end

  private

  def success_url
    checkout_success_url
  end

  def cancel_url
    checkout_cancel_url
  end
end 