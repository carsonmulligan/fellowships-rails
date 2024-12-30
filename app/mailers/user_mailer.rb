class UserMailer < ApplicationMailer
  default from: ENV['GOOGLE_ACTION_MAILER_ADDRESS']
  layout 'mailer'

  def welcome_email
    @user = params[:user]
    @url = root_url
    
    mail(
      to: @user.email,
      subject: "Welcome to Fellowships4You! 🎓",
      template_path: 'user_mailer',
      template_name: 'welcome_email'
    )
  end
end
