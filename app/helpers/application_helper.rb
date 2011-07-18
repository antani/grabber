

module ApplicationHelper

  include TweetButton

  def google_analytics_id
    ENV['GOOGLE_ANALYTICS_ID']
  end


  def dots (v)
    
    if v ==nil
      return
    end
      
    if v.length > 17 then
        v[0..17] + "..."
    else
        v
    end        



  end
end
