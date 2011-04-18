class PriceInfo
  attr_accessor :price, :author, :name, :url, :site
  def initialize(price, author, name, url, site)
    @price = price
    @author = author
    @name = name
    @url = url
    @site= site
  end
end
