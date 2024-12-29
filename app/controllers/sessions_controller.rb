class SessionsController < ApplicationController
  def omniauth
    auth = request.env['omniauth.auth']
    session[:user_id] = auth.uid
    session[:user_email] = auth.info.email
    
    redirect_to home_path, notice: 'Successfully signed in!'
  end
end
