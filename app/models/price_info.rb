class PriceInfo
  attr_accessor :price, :author, :name, :url, :site, :weight, :img, :discount, :shipping

  def initialize(price, author, name, url, site, weight, img, discount, shipping)

    @price = price
    @author = author
    @name = name
    @url = url
    @site= site
    @weight= weight
    @img= img
    @discount= discount
    @shipping= shipping

  end
end
