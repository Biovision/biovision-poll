module Biovision
  module Poll
    class ApplicationMailer < ActionMailer::Base
      default from: 'from@example.com'
      layout 'mailer'
    end
  end
end
