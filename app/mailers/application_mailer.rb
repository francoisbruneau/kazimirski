class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.mailer_sender
  layout 'mailer'
end
