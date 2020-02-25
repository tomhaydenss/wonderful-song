ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              =>  ENV['SMTP_ADDRESS'],
  :port                 =>  ENV['SMTP_PORT'],
  :authentication       =>  :plain,
  :user_name            =>  ENV['SENDGRID_USERNAME'],
  :password             =>  ENV['SENDGRID_PASSWORD'],
  :domain               =>  ENV['EMAIL_DOMAIN'],
  :enable_starttls_auto  =>  true
}