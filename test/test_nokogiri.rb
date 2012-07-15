#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'nokogiri'
require 'open-uri'
#include ActionView::Helpers::SanitizeHelper
#include ActionView::Helpers
require 'sanitize'


#url = "http://www.junglee.com/mn/search/junglee/?k=samsung+galaxy+s2"
url="http://www.ibazaarindia.com/search_advance_results.php?_txtSearchText=samsung%20galaxy%20s"
doc = Nokogiri::HTML(open(url))
#puts doc.at_css("p.prices span.pricelabel").text
#price_text = doc.search("div.productblock div.searchresult article.product div.buttons p.prices span.pricelabel:nth-child(4)").map { |e| "#{e.content}" }

doc.css("div#products div#content div.rtSelingBox div.newarvBox p span.prdsym").each do |link|
  #puts link.text.tr("₨","").gsub!(/^[\302\240|\s]*|[\302\240|\s]*$/, '')
  #.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'').tr("₨&nbsp;","").gsub(/&nbsp;/i,"")
  puts link.next_sibling().text.strip.gsub(/[A-Za-z:,\s]/,'')
end
doc.css("div#products div#content div.rtSelingBox div.newarvBox p.verdana_11 a.verdana_11").each do |name|
  puts name.text
end
doc.css("div.data h3.title span.ptBrand").each do |author|
  puts author.text
end
doc.css("div.product-block1 div.pro-block a.mosaic-backdrop").each do |url|
  puts url[:href]
end
doc.css("div#products div#content div.rtSelingBox div.newarvBox div.imgBox a img").each do|img|
  puts img[:src]
end
