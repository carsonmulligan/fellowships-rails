class PagesController < ApplicationController
  def pricing
    # Redirect to root if user is not authenticated
    unless session[:user_id]
      redirect_to root_path, alert: "Please sign in first"
      return
    end
  end
end 