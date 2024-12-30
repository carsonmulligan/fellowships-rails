class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    session[:user_id] = auth.uid
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
