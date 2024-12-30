class UserMailer < ApplicationMailer
  default from: ENV['GOOGLE_ACTION_MAILER_ADDRESS']

  def welcome_email
    @user = params[:user]
    @url = root_url
    
    mail(
      to: @user.email,
      subject: "Welcome to Fellowships4You! 🎓"
    )
  end
end
