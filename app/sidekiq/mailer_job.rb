require 'net/smtp'

class MailerJob
  include Sidekiq::Job

  def perform(email, code)

message = <<MESSAGE_END
From: Social Layer Service <#{ENV['SMTP_MAIL_SENDER']}>
To: Social Layer User <#{email}>
Subject: Social Layer SignIn
This is an e-mail message.
Sign In Code: #{code}
MESSAGE_END

    Net::SMTP.start(ENV['SMTP_HOST'],587,ENV['SMTP_MAIL_SENDER'],ENV['SMTP_USER'],ENV['SMTP_PASSWORD']) do |smtp|
      smtp.send_message message, ENV['SMTP_MAIL_SENDER'], email
    end
  end
end
