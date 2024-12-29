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
