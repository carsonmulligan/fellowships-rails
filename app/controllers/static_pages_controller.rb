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
