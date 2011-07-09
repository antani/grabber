

module ApplicationHelper

  include TweetButton

  def google_analytics_id
    ENV['GOOGLE_ANALYTICS_ID']
  end
  
  



end
