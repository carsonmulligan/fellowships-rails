class Users::RegistrationsController < Devise::RegistrationsController
  # GET /users/sign_up
  def new
    redirect_to root_path(show_premium_modal: true)
  end
end 