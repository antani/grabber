require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.simplybooks.in/search.php?search_keyword=effective+java"
doc = Nokogiri::HTML(open(url))
#puts doc.at_css("p.prices span.pricelabel").text
#price_text = doc.search("div.productblock div.searchresult article.product div.buttons p.prices span.pricelabel:nth-child(4)").map { |e| "#{e.content}" }

doc.css("div.bookbox_tube div.book_rt div.book_rt div.book_brief div.colm2 div.product_price span.rupee").each do |link|
  puts link.text.strip
end
doc.css("div.bookbox_tube div.book_rt div.book_rt div.book_head_tube div.heading_box h4 a").each do |name|
  puts name.text
end
doc.css("div.bookbox_tube div.book_rt div.book_rt div.book_head_tube div.by").  each do |author|
  puts author.text
end
#puts price_text
