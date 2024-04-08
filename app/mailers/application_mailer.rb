# frozen_string_literal: true

# ApplicationMailer for
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
