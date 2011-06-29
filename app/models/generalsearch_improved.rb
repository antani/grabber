#!/usr/bin/env ruby

require 'timeout'
require 'amatch'
require 'nokogiri'

include Amatch

class Generalsearch_improved

  @@logger = Logger.new(STDOUT)
  @@hydra = Typhoeus::Hydra.new
  attr_accessor :search_term,:search_type

  def initialize(given_search_term,search_type)
    self.search_term= given_search_term
    self.search_type= search_type

  end
  def perform
    @@logger.info("Performing job for #{self.search_term}")
    prices = self.class.prices(self.search_term,self.search_type)
    Rails.cache.write(self.cache_key, prices)
   


#    @topsearches  = @db.collection('topsearches')
#    @record = {  :query => self.cache_key,
# 	         :type => self.search_type,
#                 :count => 1#
#	         }
#    @topsearches.save(@record)

     prices
  end

  def cache_key
    "prices:#{self.search_term},#{self.search_type}".downcase
  end

  def number_of_stores
    return 13
  end

  class << self
          def prices(term,type)
                #prices_array = self.searches.map { |name,search| [search.call(query,type)] }#.sort_by { |p| p[1][:price] }
                prices_array = queue_requests(term,type)
                @@logger.info("Time to process prices : ")
                start_time = Time.now
                price_array = prices_array.flatten
                #@@logger.info(price_array)
                @@logger.info("-------------------------------------------")
                prices_array = price_array.sort_by { |p| p[:weight] }.reverse!
                ##@@logger.info(prices_array)
                top_weight = prices_array[0][:weight]
                ##@@logger.info("Top price---------------------------")
                ##@@logger.info(top_weight)
                top_prices=[]
                rest_prices=[]
                final_prices=[]
                prices_array.each do |tt|
                  if(tt[:weight] == top_weight) then
                   top_prices.push(tt) unless tt[:weight] == -999 
                 else
                   rest_prices.push(tt) unless tt[:weight] == -999 
                  end
                end
                top_prices = top_prices.sort_by { |p| p[:price].to_i }
                rest_prices = rest_prices.sort_by { |p| p[:price].to_i }
                final_prices = top_prices + rest_prices
                final_prices = final_prices.sort_by { |p| [-p[:weight], p[:price].to_i] }
                @@logger.info(Time.now - start_time)
                final_prices
          end
          #Uses Hydra to queue the HTTP requests and processes them at one go.
          def queue_requests(term,type)
                     @@logger.info(term)
                     @@logger.info(type)
                     mtype = type[:search_type]
                     hydra = Typhoeus::Hydra.new

                     #Books and everything else
                     url= get_flipkart_url(term, type)
                     
                     req_flip= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_flip.on_complete do |response|
                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     url= get_infibeam_url(term, type)
                     req_infibeam= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_infibeam.on_complete do |response|
                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     url= get_tradeus_url(term, type)
                     req_tradeus= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_tradeus.on_complete do |response|
                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     url= get_homeshop_url(term, type)
                     req_homeshop= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_homeshop.on_complete do |response|
                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     url= get_futurebazaar_url(term, type)
                     req_futurebazaar= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_futurebazaar.on_complete do |response|
                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     #Queue all requests
                     hydra.queue req_flip
                     hydra.queue req_infibeam
                     hydra.queue req_tradeus
                     hydra.queue req_homeshop
                     hydra.queue req_futurebazaar
                     if mtype !='movies' then
                           url= get_ebay_url(term, type)
                           req_ebay= Typhoeus::Request.new(url,:timeout=> 6000)      
                           req_ebay.on_complete do |response|
                                if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                                end  
                           end
                           hydra.queue req_ebay
                     end

                     #Only books
                     if mtype == 'books' then
                           url= get_rediff_url(term, type)
                           req_rediff= Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_rediff.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                      else
                                  page="failed"
                              end    
                           end
                           #Brings lot of crap - mute for now
			   #
		           #        url= get_nbcindia_url(term, type)
		           #        req_nbcindia= Typhoeus::Request.new(url,:timeout=> 5000)      
		           #        req_nbcindia.on_complete do |response|
		           #           if response.success?
		           #               doc= response.body
		           #               page = Nokogiri::HTML::parse(doc)
		           #               page
		           #           else
		           #                page="failed"
		           #           end    
		           #        end
                           

                           url= get_pustak_url(term, type)
                           req_pustak= Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_pustak.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                              end    
                           end

                           url= get_bookadda_url(term, type)
                           req_bookadda= Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_bookadda.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                              end    
                           end
                           url= get_crossword_url(term, type)
                           req_crossword = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_crossword.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                              end    
                           end
  
                           hydra.queue req_rediff                            
                           #hydra.queue req_nbcindia                            
                           hydra.queue req_pustak                            
                           hydra.queue req_bookadda                            
                           hydra.queue req_crossword                            
                     else
                           # no books but everything else
                           url= get_letsbuy_url(term, type)
                           req_letsbuy = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_letsbuy.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                              end    
                           end
                           hydra.queue req_letsbuy

                           url= get_adexmart_url(term, type)
                           req_adexmart = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_adexmart.on_complete do |response|
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                        else
         		           page="failed"
                              end    
                           end
                           hydra.queue req_adexmart

                     end
                #    hydra.queue req_indiaplaza

                     start_time= Time.now
                     #Blocking call for running all hydra requests
                     hydra.run
                     prices=[]

                     prices.push(parse_flipkart(req_flip.handled_response,term, type)) unless req_flip.handled_response =="failed"
                     prices.push(parse_infibeam(req_infibeam.handled_response,term, type)) unless req_infibeam.handled_response =="failed"
                     prices.push(parse_tradeus(req_tradeus.handled_response,term, type)) unless req_tradeus.handled_response =="failed"
                     prices.push(parse_homeshop(req_homeshop.handled_response,term, type)) unless req_homeshop.handled_response =="failed"
                     prices.push(parse_futurebazaar(req_futurebazaar.handled_response,term, type)) unless req_futurebazaar.handled_response =="failed"

                  #   prices.push(parse_indiaplaza(req_indiaplaza.handled_response,term, type))

                     if mtype == 'books' then
                         prices.push(parse_rediff(req_rediff.handled_response,term, type)) unless req_rediff.handled_response =="failed"
                         #prices.push(parse_nbcindia(req_nbcindia.handled_response,term, type)) unless req_nbcindia.handled_response =="failed"
                         prices.push(parse_pustak(req_pustak.handled_response,term, type)) unless req_pustak.handled_response =="failed"
                         prices.push(parse_bookadda(req_bookadda.handled_response,term, type)) unless req_bookadda.handled_response =="failed"
                         prices.push(parse_crossword(req_crossword.handled_response,term, type)) unless req_crossword.handled_response =="failed"
                     else
                         prices.push(parse_letsbuy(req_letsbuy.handled_response,term, type)) unless req_letsbuy.handled_response =="failed"
                         prices.push(parse_adexmart(req_adexmart.handled_response,term, type)) unless req_adexmart.handled_response =="failed"

                     end
                     if mtype !='movies' then
                         prices.push(parse_ebay(req_ebay.handled_response,term, type)) unless req_ebay.handled_response =="failed"
                     end
                     
                     @@logger.info ("Time for executing requests...")
                     @@logger.info (Time.now - start_time)
                     prices
          end           
#----------------------------------------------------Handlers to parse the response from site-------------------------------
        def parse_flipkart(page, query, type)
                 begin
                      @@logger.info("Parsing Flipkart")

                      price_text = page.search("div#search_results div.fk-srch-item div.dlvry-det .price").map { |e| "#{e.content}" }
                      
                      name_text = page.search("div#search_results div.fk-srch-item h2 a:first-child").map{ |e| "#{e.content} " }
                      author_text = page.search("span.head-tail a:first-child b").map {|e| "#{e.content}" }
                      url_text = []
                      page.search("div#search_results div.fk-srch-item h2 a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      img_text = []
                      page.search("div.rposition img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                     
                      discount_text = page.css("span.discount").map { |e| "#{e.content}" }
                      shipping_text = page.css("div.ship-det b:nth-child(2)").map { |e| "#{e.content}" } 
                      prices=[]
                      (0...price_text.length).each do |i|
                          @@logger.info(name_text[i])
                          @@logger.info(price_text[i])
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://flipkart.com"+url_text[i], :source=>'Flipkart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
                    rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_infibeam(page, query, type)
                     begin   
                        what = type[:search_type]

                        @@logger.info("Parsing infibeam")
                        @@logger.info(what)
                        #price_text=[]
                        #author_text = []
                        #name_text= []
                        #url_text = []
                        #img_text= []
                        discount_text = ""
                        shipping_text = ""
                        if what == 'books' then
                              price_text = page.search("div.price b").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                              name_text = page.search("ul.search_result h2.simple a:first-child").map{ |e| "#{e.content} " }
                              author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                              url_text = []
                              page.search("ul.search_result h2.simple a:first-child").each do |link|
                                 url_text << link.attributes['href'].content
                              end 	
                              img_text = []
                              page.search("ul.search_result div.img img:first-child").each do |img|
                                 img_text << img.attributes['src'].content
                              end
                        elsif what == 'mobiles' then
                              price_text = page.search("div#resultsPane ul.srch_result li div.price span.price").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                              name_text = page.search("div#resultsPane ul.srch_result li a span.title").map{ |e| "#{e.content} " }
                              author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                              url_text = []
                              page.search("div#resultsPane ul.srch_result li a:first-child").each do |link|
                                 url_text << link.attributes['href'].content
                              end 	
                              img_text = []
                              page.search("div#resultsPane ul.srch_result li a img").each do |img|
                                 img_text << img.attributes['src'].content
                              end
                        else
                              price_text = page.search("ul.srch_result li div.price span.normal").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                            #  @@logger.info(price_text)
                              name_text = page.search("ul.srch_result li span.title").map{ |e| "#{e.content} " }
                             # @@logger.info(name_text)
                              author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                            #  @@logger.info(author_text)

                              url_text = []
                              page.search("ul.srch_result li a:first-child").each do |link|
                                 url_text << link.attributes['href'].content
                              end 	
                           #   @@logger.info(url_text)
                              
                              img_text = []
                              page.search("ul.srch_result li a:first-child img:first-child").each do |img|
                                 img_text << img.attributes['src'].content
                              end
                          #    @@logger.info(img_text)

                        end
                        prices=[]
                        (0...price_text.length).each do |i|
                         #         @@logger.info(price_text[i])
                         #         @@logger.info(name_text[i])
 
                              if what == 'books' then
                                 if (name_text[i] == nil && author_text[i] != nil) then
                                        weight,cost = find_weight(author_text[i], "#{query}" )
                                  elsif (name_text[i] !=nil && author_text[i] == nil) then
                                        weight,cost = find_weight(name_text[i], "#{query}" )
                                  else
                                        weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query}" )
                                  end      
                              else 
                                  if(name_text[i] != nil) then
                                    weight,cost = find_weight(name_text[i],"#{query}")
                                  else 
                                    weight,cost = 0,0
                                  end  
                              end  

                              if (weight > 0) then
                              price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :img=>img_text[i],:url=>"http://infibeam.com"+url_text[i], :source=>'Infibeam', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                              prices.push(price_info)
                              end
                         end
                    rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_rediff(page, query,type)
            @@logger.info('Searching Rediff')
            begin
                      price_text = page.search("font#book-pric").map { |e| "#{e.content}" }
                      @@logger.info(price_text)
                      name_text = page.search("font#book-titl").map{ |e| "#{e.content} " }
                      @@logger.info(name_text)
                      author_text = page.search("font#book-auth").map {|e| "#{e.content}" }
                      @@logger.info(author_text)

                      url_text = []
                          page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail2 b a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      @@logger.info(url_text)
                      img_text = []
                      page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail1 a img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      @@logger.info(img_text)
                      discount_text = ""
                      shipping_text = ""
                      @@logger.info(discount_text)
                      @@logger.info(shipping_text)
                      prices=[]

                      (0...price_text.length).each do |i|
                         @@logger.info(price_text[i])
                         @@logger.info(name_text[i])
                         @@logger.info(author_text[i])
                         @@logger.info(url_text[i])

                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Rediff', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end

              prices
          end

          def parse_indiaplaza(page, query, type)
            @@logger.info('Parsing indiaplaza')

            price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.content}" }
            @@logger.info(price_text)
            name_text = page.search("ul.bookdetails li a").map{ |e| "#{e.content} " }
            author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
	    url_text = []
            page.search("ul.bookdetails li a").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            img_text = []
            page.search("div.tier1box1 img").each do |img|
		img_text << img.attributes['src'].content
	    end
	   
            discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
            shipping_text = ""
            prices = []

            (0...price_text.length).each do |i|
		author_text[i] = author_text[i].gsub('Author:', '')
                #@@logger.info (price_text[i])
                #@@logger.info (author_text[i])
                #@@logger.info (name_text[i])
                if (name_text[i] == nil && author_text[i] != nil) then
                      weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author_text[i] == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                end      
                final_price = price_text[i].to_s.tr('A-Za-z.,','')
                if (weight > 0) then
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.indiaplaza.com"+url_text[i], :source=>'IndiaPlaza', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
              prices 
          end


          def parse_nbcindia(page,query,type)
                      @@logger.info('Parsing nbcindia')
                begin      
                      price_text = page.search("div.fieldset ul li:nth-child(2) font").map { |e| "#{e.content}" }
                      @@logger.info (price_text)
                      name_text = page.search("div.fieldset ul li:first-child b").map{ |e| "#{e.content} " }
                      @@logger.info (name_text)
                      author_text = page.search("div.fieldset ul li a u").map {|e| "#{e.content}" }
                      @@logger.info (author_text )
                      url_text = []
                         page.search("div.fieldset ul li:first-child a:first-child").each do |link|
                         url_text << link.attributes['href'].content
                      end 	
                      @@logger.info (url_text )
                      img_text = []
                          page.search("div.imageset img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      @@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|
                          @@logger.info (price_text[i])
                          @@logger.info (author_text[i])
                          @@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.nbcindia.com/"+url_text[i], :source=>'NBCIndia', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                            prices.push(price_info)
                          end
                        end
               rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
               end
               prices 
          end

          def parse_pustak(page, query, type)
            @@logger.info("Parsing pustak")
            begin
                      price_text = page.search("div.search_landing_right_col span.prod_pg_prc_font").map { |e| "#{e.content}" }
                      #@@logger.info (price_text)
                      name_text = page.search("div.search_landing_right_col a.txt_bold").map{ |e| "#{e.content} " }
                      #@@logger.info (name_text)
                      author_text = page.search("div.search_landing_right_col span#author").map {|e| "#{e.content}" }
                      #@@logger.info (author_text )
                      url_text = []
                          page.search("div.search_landing_right_col a.txt_bold").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      #@@logger.info (url_text )
                      img_text = []
                          page.search("div.search_landing_left_col a img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      #@@logger.info (img_text )

                      discount_text = page.search("div.search_landing_right_col span:nth-child(11)").map { |e| "#{e.content}" }
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|
                          #@@logger.info (price_text[i])
                          #@@logger.info (author_text[i])
                          #@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://pustak.co.in"+url_text[i], :source=>'Pustak', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end

              prices
          end

          def parse_ebay(page, query,type)
            begin
                      price_text = page.search("div#ResultSet table.li tr td.prc").map { |e| "#{e.content}" }
                      #@@logger.info (price_text)
                      name_text = page.search("div#ResultSet table.li td:nth-child(2) div.ttl a").map{ |e| "#{e.content} " }
                      #@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      #@@logger.info (author_text )
                      url_text = []
                          page.search("div#ResultSet table.li td:nth-child(2) div.ttl a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      #@@logger.info (url_text )
                      img_text = []
                          page.search("img.img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                 
                      #@@logger.info (img_text )
                      discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
                      #@@logger.info (discount_text )
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          @@logger.info (price_text[i])
                          @@logger.info (author_text[i])
                          @@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'eBay', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end
              prices
          end
         
          def parse_bookadda(page,query,type)
               begin
                  price_text = page.search("div.deliveryinfo span.ourpriceredtext").map { |e| "#{e.content}" }
                  #@@logger.info (price_text)
                  name_text = page.search("div.searchpagebooktitle h2").map{ |e| "#{e.content} " }
                  #@@logger.info (name_text)
                  author_text = page.search("span.searchbookauthor a").map {|e| "#{e.content}" }
                  #@@logger.info (author_text )
                  url_text = []
                  page.search("div.searchpagebooktitle a").each do |link|
                    url_text << link.attributes['href'].content
                  end 	
                        #@@logger.info (url_text )
                  img_text = []
                  page.search("div.img img").each do |img|
                    img_text << img.attributes['src'].content
                  end
                  #@@logger.info (img_text )

                  discount_text = ""
                  shipping_text = ""
                  prices=[]

                  (0...price_text.length).each do |i|
                      #@@logger.info (price_text[i])
                      #@@logger.info (author_text[i])
                      #@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                            weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                      end      
                      final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 0) then
                        price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Bookadda', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
 		  rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                  end
                  prices
          end
          def parse_tradeus(page,query,type)
            begin
		    price_text = page.search("div.prsng label").map { |e| "#{e.content}" }
		    #@@logger.info (price_text)
		    name_text = page.search("div.search_prod_col tr td:nth-child(2) a:first-child").map{ |e| "#{e.content} " }
		    #@@logger.info (name_text)
		    author_text = page.search("span.searchbookauthor a").map {|e| "#{e.content}" }
		    #@@logger.info (author_text )
		    url_text = []
		          page.search("div.search_prod_col tr td:nth-child(2) a:first-child").each do |link|
		          url_text << link.attributes['href'].content
		    end 	
		    #@@logger.info (url_text )
		    img_text = []
		    page.search("img#pimage").each do |img|
		      img_text << img.attributes['src'].content
		    end
		    #@@logger.info (img_text )

		    discount_text = ""
		    shipping_text = ""
		    prices=[]

		    (0...price_text.length).each do |i|
		        #@@logger.info (price_text[i])
		        #@@logger.info (author_text[i])
		        #@@logger.info (name_text[i])
		        if (name_text[i] == nil && author_text[i] != nil) then
		              weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
		        elsif (name_text[i] !=nil && author_text[i] == nil) then
		              weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		        else
		              weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
		        end      
		        final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
		        if (weight > 0) then
		          price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.tradus.in"+url_text[i], :source=>'Tradeus', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
		          prices.push(price_info)
		        end
		      end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end
              prices
          end
          def parse_crossword(page,query,type)
              begin 
                  price_text = page.search("ul#search-result-items li span.variant-final-price").map { |e| "#{e.content}" }
                  #@@logger.info (price_text)
                  name_text = page.search("ul#search-result-items li span.variant-title").map{ |e| "#{e.content} " }
                  #@@logger.info (name_text)
                  author_text = page.search("ul#search-result-items li span.ctbr-name").map {|e| "#{e.content}" }
                  #@@logger.info (author_text )
                  url_text = []
                  page.search("ul#search-result-items li span.variant-title a").each do |link|
                      url_text << link.attributes['href'].content
                  end 	
                    #@@logger.info (url_text )
                  img_text = []
                  page.search("div.variant-image img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                    #@@logger.info (img_text )
                  prices=[]
                  discount_text = ""
                  shipping_text = ""


                  (0...price_text.length).each do |i|
                      #@@logger.info (price_text[i])
                      #@@logger.info (author_text[i])
                      #@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                            weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                      end      
                      final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 0) then
                        price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://crossword.in/"+url_text[i], :source=>'Crossword', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                  end
                  prices
          end
          def parse_homeshop(page,query,type)
                   begin
                      price_text = page.search("product_new_price").map { |e| "#{e.content}" }
                      #@@logger.info (price_text)
                      name_text = page.search("p.product_title a").map{ |e| "#{e.content} " }
                      #@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      #@@logger.info (author_text )
                      url_text = []
                          page.search("p.product_title a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      #@@logger.info (url_text )
                      img_text = []
                      page.search("p.product_image img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                 
                      #@@logger.info (img_text )
                      discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
                      #@@logger.info (discount_text )
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          #@@logger.info (price_text[i])
                          #@@logger.info (author_text[i])
                          #@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Homeshop18', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                      end
                    rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                    end
                      prices
          end

          def parse_letsbuy(page,query,type)
                  begin
                      price_text = page.search("span.text12_stb").map { |e| "#{e.content}" }
                      #@@logger.info (price_text)
                      name_text = page.search("div.detailbox h2 a").map{ |e| "#{e.content} " }
                      #@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      #@@logger.info (author_text )
                      url_text = []
                      page.search("div.detailbox h2 a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      #@@logger.info (url_text )
                      img_text = []
                      page.search("div.search_products img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      #@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          #@@logger.info (price_text[i])
                          #@@logger.info (author_text[i])
                          #@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Letsbuy', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                      end
                    rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_futurebazaar(page,query,type)
		begin
		          price_text = page.search("div.marb5 span.WebRupee + *").map { |e| "#{e.content}" }
		          #@@logger.info (price_text)
		          name_text = page.search("div.greed_prod h3 a").map{ |e| "#{e.content} " }
		          #@@logger.info (name_text)
		          author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
		          #@@logger.info (author_text )
		          url_text = []
		          page.search("div.greed_prod h3 a").each do |link|
		          url_text << link.attributes['href'].content
		          end 	
		          #@@logger.info (url_text )
		          img_text = []
		          page.search("div.ca img").each do |img|
		          img_text << img.attributes['src'].content
		          end
		         
		          #@@logger.info (img_text )
		          discount_text = page.search("div.value span.WebRupee + *").map { |e| "#{e.content}" }
		          shipping_text = ""
		          prices=[]

		          (0...price_text.length).each do |i|

		              #@@logger.info (price_text[i])
		              #@@logger.info (author_text[i])
		              #@@logger.info (name_text[i])
		              if (name_text[i] == nil && author_text[i] != nil) then
		                    weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
		              elsif (name_text[i] !=nil && author_text[i] == nil) then
		                    weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		              else
		                    weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
		              end      
		              final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
		                                               
		              if (weight > 0) then
		                price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.futurebazaar.com/"+url_text[i], :source=>'Futurebazaar', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
		                prices.push(price_info)
		              end
		           end
                   rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                    end
                   prices 
          end
          def parse_adexmart(page,query,type)
              begin
		    price_text = page.search("ul#product_list div.right_block span.price").map { |e| "#{e.content}" }
		    #@@logger.info (price_text)
		    name_text = page.search("ul#product_list div.center_block h3 a").map{ |e| "#{e.content} " }
		    #@@logger.info (name_text)
		    author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
		    #@@logger.info (author_text )
		    url_text = []
		    page.search("ul#product_list div.center_block h3 a").each do |link|
			url_text << link.attributes['href'].content
		    end 	
		    #@@logger.info (url_text )
		    img_text = []
		    page.search("ul#product_list div.center_block img").each do |img|
			img_text << img.attributes['src'].content
		    end
		   
		    #@@logger.info (img_text )
		    discount_text = ""
		    shipping_text = ""
            prices=[]

		    (0...price_text.length).each do |i|

		        #@@logger.info (price_text[i])
		        #@@logger.info (author_text[i])
		        #@@logger.info (name_text[i])
		        if (name_text[i] == nil && author_text[i] != nil) then
		              weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
		        elsif (name_text[i] !=nil && author_text[i] == nil) then
		              weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		        else
		              weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
		        end      
		        final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
		                                         
		        if (weight > 0) then
		          price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => "http://adexmart.com"+img_text[i],:url=>url_text[i], :source=>'Adexmart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
		          prices.push(price_info)
		        end
		     end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end
              prices
          end
#---------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------Helpers to find correct URL to parse------------------------------------
          def get_flipkart_url(query, type)
                  what = type[:search_type]
                  @@logger.info("Flipkart URL")
                  @@logger.info(what)
                  if what == 'movies' then
                      url="http://www.flipkart.com/search-movie?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'mobiles' then
                      url="http://www.flipkart.com/search-mobile?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'books' then
                      url="http://www.flipkart.com/search-book?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'cameras' then
                      url="http://www.flipkart.com/search-cameras?query=#{query[:search_term]}&from=all&searchGroup=cameras"
                      #url="http://www.flipkart.com/search-book?dd=0&query=#{query[:search_term]}&Search=Search"
                  else
                      url = "http://www.flipkart.com/search.php?query=#{query[:search_term]}&from=all"
                  end
                  @@logger.info(url)
                  url
          end
          def get_infibeam_url(query,type)
                  what = type[:search_type]
                  @@logger.info("Infibeam URL")
                  @@logger.info(what)
 
                  if what == 'movies' then
                      url = "http://www.infibeam.com/Movies/search?q=#{query[:search_term]}"
                  elsif what == 'mobiles' then
                      url = "http://www.infibeam.com/Mobiles/search?q=#{query[:search_term]}"
                  elsif what == 'books' then
                      url = "http://www.infibeam.com/Books/search?q=#{query[:search_term]}"
                  elsif what == 'cameras' then
                      url = "http://www.infibeam.com/Cameras/search?q=#{query[:search_term]}"
                  else
                      url = "http://www.infibeam.com/search?q=#{query[:search_term]}"
                  end
                  @@logger.info(url)
                  url

           end
           def get_rediff_url(query,type)
               url = "http://books.rediff.com/book/#{query[:search_term]}"
               url 
           end
           def get_indiaplaza_url(query,type)
                what = type[:search_type]
                if what == 'movies' then
                    url= "http://www.indiaplaza.com/newsearch/search.aspx?srchval=#{query[:search_term]}&Store=movies"
                elsif what == 'mobiles' then
                    url= "http://www.indiaplaza.com/newsearch/search.aspx?srchval=#{query[:search_term]}&Store=mobiles"
                elsif what == 'cameras' then
                    url= "http://www.indiaplaza.com/newsearch/search.aspx?srchval=#{query[:search_term]}&Store=cameras"
                else
                    url = "http://www.indiaplaza.in/search.aspx?catname=Books&srchkey=&srchVal=#{query[:search_term]}"
                end
           end

           def get_nbcindia_url(query,type)
                 url = "http://www.nbcindia.com/Search-books.asp?q=#{query[:search_term]}"
                 url
           end

           def get_pustak_url(query,type)
                 url="http://pustak.co.in/pustak/books/search?searchType=book&q=#{query[:search_term]}&page=1&type=genericSearch"
                 url
           end

           def get_ebay_url(query,type)
                mtype = type[:search_type]

                if mtype =='mobiles' then  
                    url="http://mobiles.shop.ebay.in/?_from=R40&_npmv=3&_trksid=m570&_nkw=#{query[:search_term]}&_sacat=15032"
                elsif mtype=='movies' then
                    url="http://movies.shop.ebay.in/?_from=R40&_npmv=3&_trksid=m570&_nkw=#{query[:search_term]}&n_sacat=11232"
                elsif mtype=='cameras' then
                  #url="http://cameras.shop.ebay.in/?_from=R40&_npmv=3&_trksid=m570&_nkw=#{query[:search_term]}&_sacat=625"
                    url="http://cameras.shop.ebay.in/Digital-SLR-Cameras-/43453/i.html?_nkw=#{query[:search_term]}"
                else
                    url="http://shop.ebay.in/?_from=R40&_trksid=m570&_nkw=#{query[:search_term]}&_sacat=See-All-Categories"
                end  
                
                @@logger.info("Ebay URL : " +url)
                url
           end

           def get_bookadda_url(query,type)
                url = "http://www.bookadda.com/search/#{query[:search_term]}"
                url
           end
           def get_tradeus_url(query,type)
                mtype = type[:search_type]

                if mtype =='mobiles' then  
                     url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}?filters=tid%3A552"
                elsif mtype=='movies' then
                     url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}?filters=tid%3A695"
                elsif mtype=='cameras' then
                     url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}?filters=tid%3A381"
                elsif mtype=='books' then
                     url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}?filters=tid%3A357"
                else
                     url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}"

                end  
                url
           end
           def get_crossword_url(query,type)
                url = "http://www.crossword.in/books/search?q=#{query[:search_term]}"
                url
           end
           def get_homeshop_url(query,type)
                mtype = type[:search_type]
                if mtype =='mobiles' then  
                  url= "http://www.homeshop18.com/#{query[:search_term]}/gsm-handsets/categoryid:3027/search:#{query[:search_term]}"
                elsif mtype=='cameras' then
                  url="http://camera.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
                else
                  url="http://www.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
                end 
                url 
           end

           def get_letsbuy_url(query,type)
              url= "http://www.letsbuy.com/advanced_search_result.php?keywords=#{query[:search_term]}"
              url
           end

           def get_futurebazaar_url(query,type)
              url="http://www.futurebazaar.com/search/?q=#{query[:search_term]}"
              url
           end
           def get_adexmart_url(query,type)
      	      url="http://adexmart.com/search.php?orderby=position&orderway=desc&search_query=#{query[:search_term]}&submit_search=Search"
              url
           end
#-------------------------------------------------------------------------------------------------------------------------------
            #Finds the relevance of the search result
            def find_weight(source_string, search_string)
                search_string = de_canonicalize_isbn(search_string)
                #weight = search_string.longest_subsequence_similar(source_string)
               # m = LongestSubsequence.new(source_string.downcase)
               # weight = m.match(search_string.downcase)
		#mp = PairDistance.new (source_string.downcase)
		#weight += mp.match(search_string.downcase)

		m = LongestSubsequence.new(source_string.downcase)
		weight = m.match(search_string.downcase)

		return weight,0
            end
            def de_canonicalize_isbn(text)
              unless text.nil?
               text.to_s.gsub('+', ' ')
              end
            end
          def proper_case(str)
            #st = str.to_s
            #return st.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
            return str
          end


  end #-------------------self -end

end  #-------Generalsearch_improved -end



