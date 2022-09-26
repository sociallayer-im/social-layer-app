class AuthMailMailer < ApplicationMailer
  default from: ENV['SMTP_MAIL_SENDER']
  layout 'mailer'

  def signin_email
    @email = params[:email]
    @code = params[:code]
    @url  = 'http://example.com/login'
    delivery_options = { user_name: ENV['SMTP_USER'],
                         password: ENV['SMTP_PASSWORD'],
                         address: ENV['SMTP_HOST'] }

    mail(to: @email, subject: 'Social Layer Sign In',
         delivery_method_options: delivery_options)
  end
end
