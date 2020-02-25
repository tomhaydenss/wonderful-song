class MailerPreview < ActionMailer::Preview
  # hit http://localhost:3000/rails/mailers/mailer/reset_password_instructions
  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.last, {})
  end
end