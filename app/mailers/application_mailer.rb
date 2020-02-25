# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_SENDER'] || 'from@example.com'
  layout 'mailer'
end
