class AccountsController < ApplicationController
  def setup
    # Ensure we have email in session from payment
    unless session[:checkout_email]
      redirect_to root_path, alert: 'Please complete payment first'
      return
    end

    @email = session[:checkout_email]
  end

  def create_password
    @email = session[:checkout_email]
    
    if params[:password] != params[:password_confirmation]
      render :setup, alert: 'Passwords do not match'
      return
    end

    user = User.create!(
      email: @email,
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      premium: true
    )

    sign_in(user)
    session.delete(:checkout_email)
    
    redirect_to root_path, notice: 'Welcome to Fellows! Your account is ready.'
  end
end 