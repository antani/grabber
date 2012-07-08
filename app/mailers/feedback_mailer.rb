class FeedbackMailer < ActionMailer::Base
  default :from => 'admin@cheapr.me'

  def feedback(feedback)
    @feedback = feedback
    mail(:to => 'ved.antani@gmail.com', :subject => '[Feedback for YourSite]' '#{feedback.subject}')
  end
end
