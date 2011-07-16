class Recentsearch  
  include Mongoid::Document
  
  field :query, type:String
  field :type, type:String
  field :ts, type:DateTime
  attr_accessible :query, :type, :ts

  
end 