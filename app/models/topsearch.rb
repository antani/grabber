class Topsearch  
  include Mongoid::Document
  
  field :query, type:String
  field :type, type:String
  field :cnt, type:Integer , default: 0 
  attr_accessible :query, :type, :cnt

  
end 
