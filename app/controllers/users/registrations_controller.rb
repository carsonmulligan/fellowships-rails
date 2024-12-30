class Users::RegistrationsController < Devise::RegistrationsController
  # GET /users/sign_up
  def new
    redirect_to root_path(show_premium_modal: true)
  end

  # POST /users
  def create
    super do |user|
      if user.persisted?
        UserMailer.with(user: user).welcome_email.deliver_later
      end
    end
  end
end 