class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      if session[:checkout_email] && session[:checkout_email] == @user.email
        @user.update(premium: true)
        session.delete(:checkout_email)
      end

      # Send welcome email for new users
      if @user.sign_in_count == 1
        UserMailer.with(user: user).welcome_email.deliver_later
      end

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end
end
