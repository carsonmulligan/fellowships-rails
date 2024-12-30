class AccountsController < ApplicationController
  def setup
    # Ensure we have email in session from payment
    @email = session[:checkout_email]
    unless @email
      redirect_to root_path, alert: 'Please complete payment first'
      return
    end

    # If user is already signed in with a different email, sign them out
    if current_user && current_user.email != @email
      sign_out current_user
    end
  end

  def create_password
    @email = session[:checkout_email]
    
    unless @email
      redirect_to root_path, alert: 'Please complete payment first'
      return
    end
    
    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = 'Passwords do not match'
      render :setup
      return
    end

    # Check if user already exists
    user = User.find_by(email: @email)
    
    begin
      if user
        # Update existing user
        user.update!(
          password: params[:password],
          password_confirmation: params[:password_confirmation],
          premium: true
        )
      else
        # Create new user
        user = User.create!(
          email: @email,
          password: params[:password],
          password_confirmation: params[:password_confirmation],
          premium: true
        )
      end

      # Sign in the user
      sign_in(user)
      
      # Clear the checkout email from session
      session.delete(:checkout_email)
      
      redirect_to root_path, notice: 'Welcome to Fellows! Your account is ready.'
    rescue => e
      Rails.logger.error("Account creation failed: #{e.message}")
      flash.now[:alert] = 'Account creation failed. Please try again.'
      render :setup
    end
  end
end 