#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
#include ActionView::Helpers::SanitizeHelper
#include ActionView::Helpers
require 'sanitize'

#url="http://www.landmarkonthenet.com/search/?q=samsung+galaxy+s2"
#url = "http://www.junglee.com/mn/search/junglee/?k=samsung+galaxy+s2"
#url="http://www.ibazaarindia.com/search_advance_results.php?_txtSearchText=samsung%20galaxy%20s"
#url="http://shopping.indiatimes.com/control/keywordsearch?SEARCH_STRING=Programming%20in%20ANSI%20C"
url="http://www.uread.com/search-books/wodehouse what ho".tr(" ","-")
doc = Nokogiri::HTML(open(url))
#puts doc.at_css("p.prices span.pricelabel").text
#price_text = doc.search("div.productblock div.searchresult article.product div.buttons p.prices span.pricelabel:nth-child(4)").map { |e| "#{e.content}" }

doc.css("div.product-vert-list-item div.product-vert-list-summary div.product-vert-list-price span.our-price").each do |link|
  #puts link.text.tr("₨","").gsub!(/^[\302\240|\s]*|[\302\240|\s]*$/, '')
  #.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr("₨&nbsp;","").gsub(/&nbsp;/i,"")
  #puts link.text.strip.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr('/-','')[1..-1]
  puts link.text.strip.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr("₨","")
end
doc.css("div.product-vert-list-item div.product-vert-list-summary div.product-vert-list-title h2 a").each do |name|
  puts name.text.strip
end
doc.css("div.product-vert-list-item div.product-vert-list-summary div.product-vert-list-title strong a").each do |author|
  puts author.text
end
doc.css("div.product-block1 div.pro-block a.mosaic-backdrop").each do |url|
  puts url[:href]
end
doc.css("div.product-vert-list-item div.product-vert-list-image a img").each do|img|
  puts img[:src]
end
doc.css("div.product-vert-list-item div.product-vert-list-summary div.product-shipping-info table tbody tr td b").each do |ship|
	puts ship.text
end
