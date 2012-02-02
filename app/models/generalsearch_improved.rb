#!/usr/bin/env ruby
# encoding: utf-8

require 'timeout'
require 'amatch'
require 'nokogiri'
require 'vss'


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
    #@@logger.info("Performing job for #{self.search_term} and #{self.search_type} at #{Time.now}")

    prices = self.class.prices(self.search_term,self.search_type)
    Rails.cache.write(self.cache_key, prices)
    prices
  end

  def cache_key
    "prices:#{self.search_term},#{self.search_type}".downcase
  end

  def number_of_stores
    return 20
  end

  class << self
          def prices(term,type)

                top_prices=[]
                rest_prices=[]
                final_prices=[]
                begin
                          @@logger.info("Starting to queue...")
                          prices_array = queue_requests(term,type)

                          @@logger.info("Time to process prices : ")
                          start_time = Time.now
                          price_array = prices_array.flatten
                          ###@@logger.info(price_array)
                          ###@@logger.info("-------------------------------------------")
                          prices_array = price_array.sort_by { |p| p[:weight].to_i }.reverse!
                          #prices_array = price_array.sort_by { |p| p[:weight] }
                          #####@@logger.info(prices_array)
                          top_weight = prices_array[0][:weight]
                          ###@@logger.info("Top weight---------------------------")
                          ###@@logger.info(top_weight)
                          #Prices Array is sorted by weight
                          #We create 4 weighted arrays and store each of them by price
                          prices_top_1=[]
                          prices_top_2=[]                         
                          prices_top_3=[]                                                                            
                          prices_top_4=[]                                                                            
                          top_weight_80 = top_weight * 0.9
                          top_weight_60 = top_weight * 0.7                          
                          top_weight_30 = top_weight * 0.5                          

                          prices_array.each do |tt|
                                if(tt[:weight] <= top_weight and tt[:weight] > top_weight_80) then
                                    prices_top_1.push(tt)    
                                elsif(tt[:weight] <= top_weight_80 and tt[:weight] > top_weight_60) then
                                    prices_top_2.push(tt)                              
                                elsif(tt[:weight] <= top_weight_60 and tt[:weight] > top_weight_30) then
                                    prices_top_3.push(tt)    
                                elsif(tt[:weight] <= top_weight_30) then
                                    prices_top_4.push(tt)    
                                end                                                    
                          end 
                          prices_top_1 = prices_top_1.sort_by { |p| p[:price].to_i }                                    
                          prices_top_2 = prices_top_2.sort_by { |p| p[:price].to_i }
                          prices_top_3 = prices_top_3.sort_by { |p| p[:price].to_i }
                          prices_top_4 = prices_top_4.sort_by { |p| p[:price].to_i }                                                                                      
                          final_prices= prices_top_1+prices_top_2+prices_top_3+prices_top_4
#                          prices_array.each do |tt|

#                            current_top_weight = tt[:weight] unless tt[:weight] == -999 
#                            if (current_top_weight < top_weight) then
#                              top_weight = current_top_weight
#                              top_prices = top_prices.sort_by { |p| p[:price].to_i }
#                                  top_prices.each do |tp|
#                                      rest_prices.push(tp)
#                                  end  
#                                  top_prices=[] 
#                            end  

#                            if(tt[:weight] <= top_weight) then		           
#                                 top_prices.push(tt) unless tt[:weight] == -999 
#                            end
#                          end
                          #top_prices = top_prices.sort_by { |p| p[:price].to_i }
                          #rest_prices = rest_prices.sort_by { |p| p[:price].to_i }
                          ###@@logger.info(top_prices)
                          ###@@logger.info(rest_prices)
#                          final_prices = rest_prices + top_prices  
                          #final_prices = final_prices.sort_by { |p| [-p[:weight], p[:price].to_i] }
                          ###@@logger.info(Time.now - start_time)
                          ###@@logger.info(final_prices)
                rescue => ex
                       ###@@logger.info ("#{ex.class} : #{ex.message}")
                       ###@@logger.info (ex.backtrace)
                end

                final_prices
          end
          #Uses Hydra to queue the HTTP requests and processes them at one go.
          def queue_requests(term,type)
                    ##@@logger.info(term)
                    ##@@logger.info(type)
                     mtype = type[:search_type]
                     hydra = Typhoeus::Hydra.new

                     #Books and everything else
                     url= get_flipkart_url(term, type)
                     req_flip= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_flip.on_complete do |response|
                          @@logger.info('Flipkart response')
                          @@logger.info(response.code)    # http status code
                          @@logger.info(response.time)    # time in seconds the request took 
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
                      ##@@logger.info('Infibeam response')
                      ##@@logger.info(response.code)    # http status code
                      ##@@logger.info(response.time)    # time in seconds the request took 

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
                       ###@@logger.info('tradeus response')
                       ###@@logger.info(response.code)    # http status code
                       ###@@logger.info(response.time)    # time in seconds the request took 
                       #
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
                          #@@logger.info('Homeshop response')
                          #@@logger.info(response.code)    # http status code
                          #@@logger.info(response.time)    # time in seconds the request took 

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
                          ##@@logger.info('Futurebazaar response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 

                          if response.success?
                            doc= response.body
                            page = Nokogiri::HTML::parse(doc)
                            page
                          else
                            page="failed"
                          end  
                     end
                     url= get_ebay_url(term, type)
                     req_ebay= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_ebay.on_complete do |response|
                     ##@@logger.info('Ebay response')
                     ##@@logger.info(response.code)    # http status code
                     ##@@logger.info(response.time)    # time in seconds the request took 

                               if response.success?
                                      doc= response.body
                                      page = Nokogiri::HTML::parse(doc)
                                      page
                               else
                                      page="failed"
                               end  
                     end
                     #junglee/amazon.india
                     url= get_junglee_url(term, type)
                     req_junglee= Typhoeus::Request.new(url,:timeout=> 5000)      
                     req_junglee.on_complete do |response|
                     @@logger.info('Junglee response')
                     @@logger.info(response.code)    # http status code
                     @@logger.info(response.time)    # time in seconds the request took 

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
                     hydra.queue req_ebay
                     hydra.queue req_junglee

                     if (mtype !='movies' and mtype !='books') then
                           url= get_letsbuy_url(term, type)
                           req_letsbuy = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_letsbuy.on_complete do |response|
                          ##@@logger.info('Letsbuy response')
                          ##@@logger.info(response.code)    # http status code
                           ##@@logger.info(response.time)    # time in seconds the request took 

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
                          ##@@logger.info('Adexmart response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 

                                if response.success?
                                    doc= response.body
                                    page = Nokogiri::HTML::parse(doc)
                                    page
                                else
                                    page="failed"
                                end    
                           end
                           hydra.queue req_adexmart

                           url= get_greendust_url(term, type)
                           req_greendust = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_greendust.on_complete do |response|
                           ##@@logger.info('Letsbuy response')
                           ##@@logger.info(response.code)    # http status code
                           ##@@logger.info(response.time)    # time in seconds the request took 

                                    if response.success?
                                        doc= response.body
                                        page = Nokogiri::HTML::parse(doc)
                                        page
                                    else
                                        page="failed"
                                    end    
                           end
                           hydra.queue req_greendust

                           url= get_retailmart_url(term, type)
                           req_retailmart = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_retailmart.on_complete do |response|
                           ##@@logger.info('Retailmart response')
                           ##@@logger.info(response.code)    # http status code
                           ##@@logger.info(response.time)    # time in seconds the request took 

                                    if response.success?
                                        doc= response.body
                                        page = Nokogiri::HTML::parse(doc)
                                        page
                                    else
                                        page="failed"
                                    end    
                           end
                           hydra.queue req_retailmart

                     end
                     #only movies
                     if mtype == 'movies' then
                          url= get_moviemart_url(term, type)
                          req_moviemart= Typhoeus::Request.new(url,:timeout=> 5000)      
                          req_moviemart.on_complete do |response|
                          ##@@logger.info('Rediff response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                          else
                                  page="failed"
                              end    
                          end
                          url= get_moserbaer_url(term, type)
                          req_moserbaer= Typhoeus::Request.new(url,:timeout=> 5000)      
                          req_moserbaer.on_complete do |response|
                          ##@@logger.info('Rediff response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                          else
                                  page="failed"
                              end    
                          end
                          url= get_indiatimes_url(term, type)
                          req_indiatimes= Typhoeus::Request.new(url,:timeout=> 5000)      
                          req_indiatimes.on_complete do |response|
                          ##@@logger.info('Rediff response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 
                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                          else
                                  page="failed"
                              end    
                          end
 

                          hydra.queue req_moviemart                            
                          hydra.queue req_moserbaer                            
                          hydra.queue req_indiatimes                            

                     end
                     if mtype == 'cameras' then
                           url= get_fotocenter_url(term, type)
                           req_fotocenter= Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_fotocenter.on_complete do |response|
                          ##@@logger.info('Rediff response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 

                               if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
   	                           else
                                  page="failed"
                               end    
                           end
                           hydra.queue req_fotocenter
                     end
                     #Only books
                     if mtype == 'books' then
                           url= get_rediff_url(term, type)
                           req_rediff= Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_rediff.on_complete do |response|
                          ##@@logger.info('Rediff response')
                          ##@@logger.info(response.code)    # http status code
                          ##@@logger.info(response.time)    # time in seconds the request took 

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
              #            ###@@logger.info('Pustak response')
              #            ###@@logger.info(response.code)    # http status code
              #            ###@@logger.info(response.time)    # time in seconds the request took 

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
               #           ###@@logger.info('Bookadda response')
               #           ###@@logger.info(response.code)    # http status code
               #           ###@@logger.info(response.time)    # time in seconds the request took 

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
                #          ###@@logger.info('Crossword response')
                #          ###@@logger.info(response.code)    # http status code
                #          ###@@logger.info(response.time)    # time in seconds the request took 

                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                          else
                 		          page="failed"
                              end    
                           end
                           url= get_coinjoos_url(term, type)
                           req_coinjoos = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_coinjoos.on_complete do |response|
                #          ###@@logger.info('Crossword response')
                #          ###@@logger.info(response.code)    # http status code
                #          ###@@logger.info(response.time)    # time in seconds the request took 

                              if response.success?
                                  doc= response.body
                                  page = Nokogiri::HTML::parse(doc)
                                  page
	                          else
                 		          page="failed"
                              end    
                           end
  
                           hydra.queue req_coinjoos                            
  
                           hydra.queue req_rediff                            
                           #hydra.queue req_nbcindia                            
                           hydra.queue req_pustak                            
                           hydra.queue req_bookadda                            
                           hydra.queue req_crossword                            
                     end
                     #Only Mobiles
            		     if mtype == 'mobiles' then

			               url= get_sangeeta_url(term, type)
                           req_sangeeta = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_sangeeta.on_complete do |response|
                                 ##@@logger.info('Sangeeta response')
                                 ##@@logger.info(response.code)    # http status code
                                 ##@@logger.info(response.time)    # time in seconds the request took 

                                   if response.success?
                                          doc= response.body
                                          page = Nokogiri::HTML::parse(doc)
                                          page
	                               else
                 	            	          page="failed"
                                   end    
                            end
                            hydra.queue req_sangeeta      
		             end
                     #Movies and Books
                    if (mtype =='movies' or mtype =='books') then
                           url= get_landmark_url(term, type)
                           req_landmark = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_landmark.on_complete do |response|
                              ###@@logger.info('Letsbuy response')
                              ###@@logger.info(response.code)    # http status code
                               ###@@logger.info(response.time)    # time in seconds the request took 

                                    if response.success?
                                        doc= response.body
                                        page = Nokogiri::HTML::parse(doc)
                                        page
                                    else
                                        page="failed"
                                    end    
                           end
                           hydra.queue req_landmark
                     end    
                     #Mobile and Computers
                    if (mtype =='mobiles' or mtype =='computers') then
                           url= get_ibazaar_url(term, type)
                           req_ibazaar = Typhoeus::Request.new(url,:timeout=> 5000)      
                           req_ibazaar.on_complete do |response|
                           #@@logger.info('ibazaar response')
                           #@@logger.info(response.code)    # http status code
                           #@@logger.info(response.time)    # time in seconds the request took 

                                    if response.success?
                                        doc= response.body
                                        page = Nokogiri::HTML::parse(doc)
                                        page
                                    else
                                        page="failed"
                                    end    
                           end
                           hydra.queue req_ibazaar
                     end    
                     #Mobile, cameras and Computers
                    if (mtype =='mobiles' or mtype =='cameras' or mtype =='computers') then
                           # url= get_buytheprice_url(term, type)
                           # @@logger.info("URL:#{url}")
                           # req_buytheprice = Typhoeus::Request.new(url,:timeout=> 5000)      
                           # req_buytheprice.on_complete do |response|
                           # @@logger.info('buytheprice response')
                           # @@logger.info(response.code)    # http status code
                           # @@logger.info(response.time)    # time in seconds the request took                            

                           #          if response.success?
                           #              doc= response.body
                           #              page = Nokogiri::HTML::parse(doc)
                           #              page
                           #          else
                           #              page="failed"
                           #          end    
                           # end
                           # hydra.queue req_buytheprice
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
                     prices.push(parse_ebay(req_ebay.handled_response,term, type)) unless req_ebay.handled_response =="failed"
                     prices.push(parse_junglee(req_junglee.handled_response,term, type)) unless req_junglee.handled_response =="failed"

                     if mtype == 'movies' then
                               prices.push(parse_moviemart(req_moviemart.handled_response,term, type)) unless req_moviemart.handled_response =="failed"
                               prices.push(parse_indiatimes(req_indiatimes.handled_response,term, type)) unless req_indiatimes.handled_response =="failed"
                               prices.push(parse_moserbaer(req_moserbaer.handled_response,term, type)) unless req_moserbaer.handled_response =="failed"
                     end
                     if mtype == 'mobiles' then
                               prices.push(parse_sangeeta(req_sangeeta.handled_response,term, type)) unless req_sangeeta.handled_response =="failed"
                     end
                     if mtype == 'cameras' then
                               prices.push(parse_fotocenter(req_fotocenter.handled_response,term, type)) unless req_fotocenter.handled_response =="failed"
                     end
                     if mtype == 'books' then
                         prices.push(parse_rediff(req_rediff.handled_response,term, type)) unless req_rediff.handled_response =="failed"
                         #prices.push(parse_nbcindia(req_nbcindia.handled_response,term, type)) unless req_nbcindia.handled_response =="failed"
                         prices.push(parse_pustak(req_pustak.handled_response,term, type)) unless req_pustak.handled_response =="failed"
                         prices.push(parse_bookadda(req_bookadda.handled_response,term, type)) unless req_bookadda.handled_response =="failed"
                         prices.push(parse_crossword(req_crossword.handled_response,term, type)) unless req_crossword.handled_response =="failed"
                         prices.push(parse_coinjoos(req_coinjoos.handled_response,term, type)) unless req_coinjoos.handled_response =="failed"
                     end
                     if (mtype !='movies' and mtype != 'books') then
                         prices.push(parse_letsbuy(req_letsbuy.handled_response,term, type)) unless req_letsbuy.handled_response =="failed"
                         prices.push(parse_adexmart(req_adexmart.handled_response,term, type)) unless req_adexmart.handled_response =="failed"
                         prices.push(parse_greendust(req_greendust.handled_response,term, type)) unless req_greendust.handled_response =="failed"
                         prices.push(parse_retailmart(req_retailmart.handled_response,term, type)) unless req_retailmart.handled_response =="failed"
                     end
                     if (mtype =='movies' or mtype =='books') then
                         prices.push(parse_landmark(req_landmark.handled_response,term, type)) unless req_landmark.handled_response =="failed"
                     end
                     if (mtype =='mobiles' or mtype =='computers') then
                         prices.push(parse_ibazaar(req_ibazaar.handled_response,term, type)) unless req_ibazaar.handled_response =="failed"
                     end 
                     #Mobile, cameras and Computers
                    if (mtype =='mobiles' or mtype =='cameras' or mtype =='computers') then
                      # prices.push(parse_buytheprice(req_buytheprice.handled_response,term, type)) unless req_buytheprice.handled_response =="failed"
                    end  
                     ##@@logger.info ("Time for executing requests...")
                     ##@@logger.info (Time.now - start_time)
                     prices
          end           
#----------------------------------------------------Handlers to parse the response from site-------------------------------
        def parse_flipkart(page, query, type)
                 begin
                      ###@@logger.info("Parsing Flipkart")
                      what = type[:search_type]
                      if what == 'mobiles' then
                        price_text = page.search("div#search_results.search_results div.line div.unit div.line div b.price").map { |e| "#{e.content}" }
                        name_text = page.search("div#search_results.search_results div.line div.unit h2 a").map{ |e| "#{e.content} " }                      
                        author_text = ""
                        url_text = []
                            page.search("div#search_results.search_results div.line div.unit h2 a").each do |link|
                            url_text << link.attributes['href'].content
                        end 	
                        img_text = []
                            page.search("div#search_results.search_results div.line div.unit div.line div.lastUnit a img").each do |img|
                            img_text << img.attributes['src'].content
                        end

                        discount_text = page.search("div#search_results.search_results div.line div.unit div.line div.unit b").map { |e| "#{e.content}" }
                        shipping_text = page.css("div#search_results.search_results div.line div.unit div.search_page_offers div.offers_text").map { |e| "#{e.content}" }                     
                        ###@@logger.info("Length of flipkart - #{price_text.length}") 
                      else
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
                          discount_text = page.css("div#search_results.search_results div.line div.unit div.line div.line div.line div.discount").map { |e| "#{e.content}" }
                          shipping_text = page.css("div#search_results.search_results div.line div.unit div.line div.ship-det").map { |e| "#{e.content}" } 
                       end
                      prices=[]
                      (0...price_text.length).each do |i|
                          ###@@logger.info(name_text[i])
                          ###@@logger.info(price_text[i])
                          ###@@logger.info(author_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                         
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author
                                 #weight,cost = find_weight(name_text[i] + " " +author_text[i], "#{query[:search_term]}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://flipkart.com"+url_text[i]+"?affid=vedantanig", :source=>'Flipkart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
                    rescue => ex
                        @@logger.info ("#{ex.class} : #{ex.message}")
                        @@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_infibeam(page, query, type)
                     begin   
                        what = type[:search_type]

                        ###@@logger.info("Parsing infibeam")
                        ####@@logger.info(what)
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
                              discount_text = page.search("div#search_result ul.search_result li div.price span[@style*='E47911']").map {|e| "#{e.content}" }
                        elsif what == 'mobiles' or what=='computers' then
                              price_text = page.search("div#resultsPane ul.srch_result li div.price span.normal").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
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
                        elsif what == 'movies' then
                              price_text = page.search("div#search_result ul.search_result li div.price b").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                              name_text = page.search("div#search_result ul.search_result li h2 a").map{ |e| "#{e.content} " }
                              author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                              url_text = []
                              page.search("div#search_result ul.search_result li h2 a").each do |link|
                                 url_text << link.attributes['href'].content
                              end 	
                              img_text = []
                              page.search("div#search_result ul.search_result li div.img a img").each do |img|
                                 img_text << img.attributes['src'].content
                              end

                        else
                              price_text = page.search("ul.srch_result li div.price span.normal").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                            #  ###@@logger.info(price_text)
                              name_text = page.search("ul.srch_result li span.title").map{ |e| "#{e.content} " }
                             # ###@@logger.info(name_text)
                              author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                            #  ###@@logger.info(author_text)

                              url_text = []
                              page.search("ul.srch_result li a:first-child").each do |link|
                                 url_text << link.attributes['href'].content
                              end 	
                           #   ###@@logger.info(url_text)
                              img_text = []
                              page.search("ul.srch_result li a:first-child img:first-child").each do |img|
                                 img_text << img.attributes['src'].content
                              end
                          #    ###@@logger.info(img_text)

                        end
                        prices=[]
                        (0...price_text.length).each do |i|
                                  ###@@logger.info(price_text[i])
                                  ###@@logger.info(name_text[i])
                                  ###@@logger.info(author_text[i]) 
                                    #Strip invalid UTF-8 Characters
                                    name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                                    author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                         
                              if what == 'books' then
                                 if (name_text[i] == nil && author_text[i] != nil) then
                                        weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                  elsif (name_text[i] !=nil && author_text[i] == nil) then
                                        weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                  else
                                        weight_author=0
                                        weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                        weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                        weight = weight_name + weight_author
#                                         weight,cost = find_weight(name_text[i] + " " +author_text[i], "#{query[:search_term]}" )
                                  end      
                              else 
                                  if(name_text[i] != nil) then
                                    weight,cost = find_weight(name_text[i],"#{query[:search_term]}")
                                  else 
                                    weight,cost = 0,0
                                  end  
                              end  
                              if ( i >0 )  then
                                break
                              end
                              if (weight > 1) then
                              price_info = {:price => digitize_price(price_text[i]),:author=>author_text[i], :name=>name_text[i], :img=>img_text[i],:url=>"http://infibeam.com"+url_text[i], :source=>'Infibeam', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text} 
                              prices.push(price_info)
                              end
                         end
                    rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_rediff(page, query,type)
            ###@@logger.info('Searching Rediff')
            begin
                      price_text = page.search("font#book-pric").map { |e| "#{e.content}" }
                      ####@@logger.info(price_text)
                      name_text = page.search("font#book-titl").map{ |e| "#{e.content} " }
                      ####@@logger.info(name_text)
                      author_text = page.search("font#book-auth").map {|e| "#{e.content}" }
                      ####@@logger.info(author_text)

                      url_text = []
                          page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail2 b a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info(url_text)
                      img_text = []
                      page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail1 a img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      ####@@logger.info(img_text)
                      discount_text = ""
                      shipping_text = ""
                      ####@@logger.info(discount_text)
                      ####@@logger.info(shipping_text)
                      prices=[]

                      (0...price_text.length).each do |i|

                        if i > 3
                          break
                        end  
                       #  ###@@logger.info(price_text[i])
                       #  ###@@logger.info(name_text[i])
                       #  ###@@logger.info(author_text[i])
                       #  ###@@logger.info(url_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                        

                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author
#                                weight,cost = find_weight(name_text[i] + " " +author_text[i], "#{query[:search_term]}" )           			        
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Rediff', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end

              prices
          end

          def parse_indiaplaza(page, query, type)
            ###@@logger.info('Parsing indiaplaza')

            price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.content}" }
            ####@@logger.info(price_text)
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
                ####@@logger.info (price_text[i])
                ####@@logger.info (author_text[i])
                ####@@logger.info (name_text[i])
              #Strip invalid UTF-8 Characters
              name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
              author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                        

                if (name_text[i] == nil && author_text[i] != nil) then
                      weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author_text[i] == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight_author=0
                      weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
        		          weight = weight_name + weight_author

                end      
                      final_price = price_text[i].to_s.tr('A-Za-z.,','')
                if (weight > 1) then
                  price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.indiaplaza.com"+url_text[i], :source=>'IndiaPlaza', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
              prices 
          end


          def parse_nbcindia(page,query,type)
                      ###@@logger.info('Parsing nbcindia')
                begin      
                      price_text = page.search("div.fieldset ul li:nth-child(2) font").map { |e| "#{e.content}" }
                      ###@@logger.info (price_text)
                      name_text = page.search("div.fieldset ul li:first-child b").map{ |e| "#{e.content} " }
                      ###@@logger.info (name_text)
                      author_text = page.search("div.fieldset ul li a u").map {|e| "#{e.content}" }
                      ###@@logger.info (author_text )
                      url_text = []
                         page.search("div.fieldset ul li:first-child a:first-child").each do |link|
                         url_text << link.attributes['href'].content
                      end 	
                      ###@@logger.info (url_text )
                      img_text = []
                          page.search("div.imageset img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      ###@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|
                          ###@@logger.info (price_text[i])
                          ###@@logger.info (author_text[i])
                          ###@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                         
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
                          end      
                                                final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.nbcindia.com/"+url_text[i], :source=>'NBCIndia', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                            prices.push(price_info)
                          end
                        end
               rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
               end
               prices 
          end

          def parse_pustak(page, query, type)
            ###@@logger.info("Parsing pustak")
            begin
                      price_text = page.search("div.search_landing_right_col span.prod_pg_prc_font").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("div.search_landing_right_col a.txt_bold").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = page.search("div.search_landing_right_col span#author").map {|e| "#{e.content}" }
                      ####@@logger.info (author_text )
                      url_text = []
                          page.search("div.search_landing_right_col a.txt_bold").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                          page.search("div.search_landing_left_col a img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                      ####@@logger.info (img_text )
 
                      discount_text = page.search("div.search_result_holder div.prod_search_coll_holder div.search_landing_right_col span[@style*='666666']").map { |e| "#{e.content}" }
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|
                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                        
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://pustak.co.in"+url_text[i], :source=>'Pustak', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end

              prices
          end

          def parse_ebay(page, query,type)
            begin
            	      ###@@logger.info("Parsing ebay")

                      price_text = page.search("div#ResultSet table.li tr td.prc").map { |e| "#{e.content}" }
                      ###@@logger.info (price_text)
                      name_text = page.search("div#ResultSet table.li td:nth-child(2) div.ttl a").map{ |e| "#{e.content} " }
                      ###@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      ###@@logger.info (author_text )
                      url_text = []
                          page.search("div#ResultSet table.li td:nth-child(2) div.ttl a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ###@@logger.info (url_text )
                      img_text = []
                          page.search("img.img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                 
                      ###@@logger.info (img_text )
                      discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
                      ####@@logger.info (discount_text )
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

             #             ###@@logger.info (price_text[i])
             #             ###@@logger.info (author_text[i])
             #             ###@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
             
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'eBay', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end

          def parse_junglee(page, query,type)
            begin
                      @@logger.info("Parsing junglee")

                      price_text = page.search("div.data div.prodAds span.price").map { |e| "#{e.content}" }
                      #@@logger.info (price_text)
                      name_text = page.search("div.data div.title a.title").map{ |e| "#{e.content} " }
                      #@@logger.info (name_text)
                      author_text = page.search("div.data div.title span.ptBrand").map {|e| "#{e.content}" }
                      #@@logger.info (author_text )
                      url_text = []
                          page.search("div.data div.title a.title").each do |link|
                      url_text << link.attributes['href'].content
                      end   
                      #@@logger.info (url_text )
                      img_text = []
                          page.search("div.image a img.productImage").each do |img|
                          img_text << img.attributes['src'].content
                      end
                 
                      #@@logger.info (img_text )
                      discount_text = ""
                      ####@@logger.info (discount_text )
                      shipping_text = page.search("div.data div.offerCount").map { |e| "#{e.content}" }
                      prices=[]

                      (0...price_text.length).each do |i|

                          #@@logger.info (price_text[i])
                          #@@logger.info (author_text[i])
                          #@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
             
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author

                          end      
                          final_price = strip_invalid_utf8_chars(price_text[i]).to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                          final_price = final_price.tr("₨","")                                 
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Junglee', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
              rescue => ex
                        @@logger.info ("#{ex.class} : #{ex.message}")
                        @@logger.info (ex.backtrace)
              end
              prices
          end


         
          def parse_bookadda(page,query,type)
              ###@@logger.info ("parsing bookadda")
               begin
                  price_text = page.search("div.deliveryinfo span.ourpriceredtext").map { |e| "#{e.content}" }
                  ####@@logger.info (price_text)
                  name_text = page.search("div.searchpagebooktitle h2").map{ |e| "#{e.content} " }
                  ####@@logger.info (name_text)
                  author_text = page.search("span.searchbookauthor a").map {|e| "#{e.content}" }
                  ####@@logger.info (author_text )
                  url_text = []
                  page.search("div.searchpagebooktitle a[@href*=product]").each do |link|
                    url_text << link.attributes['href'].content
                  end 	
                        ####@@logger.info (url_text )
                  img_text = []
                  page.search("div.img img").each do |img|
                    img_text << img.attributes['src'].content
                  end
                  ####@@logger.info (img_text )

 
                  discount_text = ""
                  shipping_text = page.search("span.item_shipping").map {|e| "#{e.content}" }                  
                  prices=[]

                  (0...price_text.length).each do |i|
                  
                      if i>0 then
                        break
                      end  
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      #Strip invalid UTF-8 Characters
                      name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                      author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                      
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                      end      
                      final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 1 and final_price.to_i > 0) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Bookadda', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
 		  rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                  end
                  prices
          end
          def parse_tradeus(page,query,type)
            ###@@logger.info ("parsing tradeus")
            begin
          		    price_text = page.search("div.productDetails div.productRatingPrice div.productPrice span strong").map { |e| "#{e.content}" }
          		    ####@@logger.info (price_text)
          		    name_text = page.search("div.productDetails div.productHeading a").map{ |e| "#{e.content} " }
          		    ####@@logger.info (name_text)
          		    author_text = page.search("span.searchbookauthor a").map {|e| "#{e.content}" }
          		    ####@@logger.info (author_text )
          		    url_text = []
          		          page.search("div.productDetails div.productHeading a").each do |link|
          		          url_text << link.attributes['href'].content
          		    end 	
          		    ####@@logger.info (url_text )
          		    img_text = []
          		    page.search("div.searchResultContainer div.productImage a img.imagecache").each do |img|
          		      img_text << img.attributes['src'].content
          		    end
          		    ####@@logger.info (img_text )
 
          		    discount_text = page.search("div.productDetails div.productRatingPrice div.productSave span strong").map {|e| "#{e.content}" }
          		    shipping_text = ""
          		    prices=[]

  		    (0...price_text.length).each do |i|


              if (i >0)
                break
              end  
  		        ####@@logger.info (price_text[i])
  		        ####@@logger.info (author_text[i])
  		        ####@@logger.info (name_text[i])
                  #Strip invalid UTF-8 Characters
                  name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                  author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
  		        
  		        if (name_text[i] == nil && author_text[i] != nil) then
  		              weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
  		        elsif (name_text[i] !=nil && author_text[i] == nil) then
  		              weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
  		        else
                    weight_author=0
                    weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                    weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                    weight = weight_name + weight_author

  		        end      
  		        final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
  		        if (weight > 1) then
  		          price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Tradeus', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
  		          prices.push(price_info)
  		        end
  		      end
                rescue => ex
                          ####@@logger.info ("#{ex.class} : #{ex.message}")
                          ####@@logger.info (ex.backtrace)
                end
                prices
          end

          def parse_crossword(page,query,type)
            ###@@logger.info ("parsing crossword")          
              begin 
                  price_text = page.search("ul#search-result-items li span.variant-final-price").map { |e| "#{e.content}" }
                  ####@@logger.info (price_text)
                  name_text = page.search("ul#search-result-items li span.variant-title").map{ |e| "#{e.content} " }
                  ####@@logger.info (name_text)
                  author_text = page.search("ul#search-result-items li span.ctbr-name").map {|e| "#{e.content}" }
                  ####@@logger.info (author_text )
                  url_text = []
                  page.search("ul#search-result-items li span.variant-title a").each do |link|
                      url_text << link.attributes['href'].content
                  end 	
                    ####@@logger.info (url_text )
                  img_text = []
                  page.search("div.variant-image img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                    ####@@logger.info (img_text )
                  prices=[]
                  shipping_text = page.search("span.ships-in").map {|e| "#{e.content}" }
                   

                  discount_text = ""


                  (0...price_text.length).each do |i|
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      
                      if (i > 0 ) then
                        break
                      end  
                      
                      #Strip invalid UTF-8 Characters
                      name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                      author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                      
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                      end      
                                            final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://crossword.in/"+url_text[i], :source=>'Crossword', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                  end
                  prices
          end
          def parse_homeshop(page,query,type)
            
            ##@@logger.info ("parsing homeshop")          
                   begin
                      price_text = page.search("div.product_div span.product_new_price").map { |e| "#{e.content}" }
                      ##@@logger.info (price_text)
                      name_text = page.search("p.product_title a").map{ |e| "#{e.content} " }
                      ##@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      ##@@logger.info (author_text )
                      url_text = []
                          page.search("p.product_title a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      ##@@logger.info (url_text )
                      img_text = []
                      page.search("p.product_image img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                 
                      ####@@logger.info (img_text )
                      discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
                      ####@@logger.info (discount_text )
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|
                          if i > 3
                            break
                          end 

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Homeshop18', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                      end
                    rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                    end
                      prices
          end

          def parse_letsbuy(page,query,type)
            ##@@logger.info ("parsing letsbuy")          
                  begin
                      price_text = page.search("span.text12_stb").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("div.detailbox h2 a").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("div.detailbox h2 a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("div.search_products img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          if i > 5
                            break
                          end   
                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Letsbuy', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                      end
                    rescue => ex
                        ##@@logger.info ("#{ex.class} : #{ex.message}")
                        ##@@logger.info (ex.backtrace)
                    end
                    prices
          end

          def parse_futurebazaar(page,query,type)
            ###@@logger.info ("parsing futurebazaar")          
            what = type[:search_type]
  		    begin
              if what == 'computers'
                    price_text = page.search("div#content div#content_area div.greed_view ul.greed li div.greed_prod div.price div.fb").map { |e| "#{e.content}" }
                    ####@@logger.info (price_text)
                    name_text = page.search("div#content_area div.greed_view ul.greed li div.greed_prod h3 a").map{ |e| "#{e.content} " }
                    ####@@logger.info (name_text)
                    author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                    ####@@logger.info (author_text )
                    url_text = []
                    page.search("div#content_area div.greed_view ul.greed li div.greed_prod h3 a").each do |link|
                        url_text << link.attributes['href'].content
                    end   
                    ####@@logger.info (url_text )
                    img_text = []
                    page.search("div#content_area div.greed_view ul.greed li div.greed_prod div.ca a img").each do |img|
                        img_text << img.attributes['src'].content
                    end

                    ####@@logger.info (img_text )
                    discount_text = page.search("div#content_area div.greed_view ul.greed li div.greed_prod div.you_save span.save_value").map { |e| "#{e.content}" }
                    shipping_text = ""
              else  
                    price_text = page.search("div.marb5 span.WebRupee + *").map { |e| "#{e.content}" }
                    ####@@logger.info (price_text)
                    name_text = page.search("div.greed_prod h3 a").map{ |e| "#{e.content} " }
                    ####@@logger.info (name_text)
                    author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
                    ####@@logger.info (author_text )
                    url_text = []
                    page.search("div.greed_prod h3 a").each do |link|
                        url_text << link.attributes['href'].content
                    end 	
                    ####@@logger.info (url_text )
                    img_text = []
                    page.search("div.ca img").each do |img|
                        img_text << img.attributes['src'].content
                    end
		          end
		          ####@@logger.info (img_text )
		          discount_text = page.search("div.value span.WebRupee + *").map { |e| "#{e.content}" }
		          shipping_text = ""
		          prices=[]

		          (0...price_text.length).each do |i|

		              ####@@logger.info (price_text[i])
		              ####@@logger.info (author_text[i])
		              ####@@logger.info (name_text[i])
                      #Strip invalid UTF-8 Characters
                      name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                      author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
		              
		              if (name_text[i] == nil && author_text[i] != nil) then
		                    weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
		              elsif (name_text[i] !=nil && author_text[i] == nil) then
		                    weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		              else
		                        weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		                        weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
					            weight = weight_name + weight_author

		              end      
		              final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
		                                               
		              if (weight > 1) then
		                price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.futurebazaar.com/"+url_text[i], :source=>'Futurebazaar', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
		                prices.push(price_info)
		              end
		           end
                   rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                    end
                   prices 
          end
          def parse_adexmart(page,query,type)
            #@@logger.info ("parsing adexmart")          
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

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => "http://adexmart.com"+img_text[i],:url=>url_text[i], :source=>'Adexmart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
              end
              prices
          end

          def parse_moviemart(page,query,type)
            ###@@logger.info ("parsing moviemart")          
              begin
                      price_text = page.search("table tbody tr td span#dtMiddle_ctl01_lblMrpInRs").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("table tbody tr td.Height strong a#lnkSell").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = ""
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("table tbody tr td.Height strong a#lnkSell").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("table tbody tr td a img#ImgMovie").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.moviemart.in/sales/"+url_text[i], :source=>'Moviemart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end
          def parse_moserbaer(page,query,type)
            ###@@logger.info ("parsing moserbaer")          
              begin
                      price_text = page.search("div.rightsearchframeaddtocartarealeft div.innerrowforall:nth-child(3) span.change").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("div.innerrowforall_search div.rightsearchframe div.innerrowforall span.change_h1").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = ""
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("div.innerrowforall_search div.leftsearchimageframe a.thumbnail").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("div.innerrowforall_search div.leftsearchimageframe a.thumbnail img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.moserbaerhomevideo.com/"+url_text[i], :source=>'Moserbaer', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end

          def parse_indiatimes(page,query,type)
            ###@@logger.info ("parsing indiatimes")          
              begin
                      price_text = page.search("table.gridViewNametd tbody tr td.link table tbody tr td span.Blackstrikered:nth-child(4)").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("table.gridViewNametd div#parent span.bold").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = ""
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("table.gridViewNametd div#parent a.searchLinks1").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("table.gridView tr td.searchimgtd img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          #Strip invalid UTF-8 Characters
                          name_text[i] = strip_invalid_utf8_chars(name_text[i] + ' ')[0..-2] unless name_text[i] == nil
                          author_text[i] = strip_invalid_utf8_chars(author_text[i] + ' ')[0..-2] unless author_text[i] == nil                     
                          
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://shopping.indiatimes.com/"+url_text[i], :source=>'Indiatimes', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end

	def parse_sangeeta(page,query,type)
            ###@@logger.info ("parsing sangeeta")	
              begin
                      price_text = page.search("span.mtb-price label.mtb-ofr").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("div.mtb-details h4.mtb-title").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = ""
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("div.bucket_left div.mtb-imgdiv a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("div.mtb-imgdiv a img.mtb-img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                      discount_text = ""
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          if i>0 then
                            break
                          end    
                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.sangeethamobiles.com"+url_text[i], :source=>'Sangeetha Mobile', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end
	def parse_landmark(page,query,type)
            ###@@logger.info ("parsing landmark")	
              begin
                      price_text = page.search("span#ctl00_ContentPlaceHolder1_rptBook_ctl00_lblsplprice").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("a#ctl00_ContentPlaceHolder1_rptBook_ctl00_lnkttl").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      author_text = ""
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("a#ctl00_ContentPlaceHolder1_rptBook_ctl00_lnkttl").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("input#ctl00_ContentPlaceHolder1_rptBook_ctl00_imgBook").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                       
                      discount_text = page.search("span#ctl00_ContentPlaceHolder1_rptBook_ctl00_lblsaveprice").map{ |e| "#{e.content} " }
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                          final_price=final_price.tr('/-','')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.landmarkonthenet.com"+url_text[i], :source=>'Landmark', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end
     	def dont_endparse_rightbooks(page,query,type)
              begin
                      price_text = page.search("span.footer_author1").map { |e| "#{e.content}" }
                      ####@@logger.info (price_text)
                      name_text = page.search("span.about2_name").map{ |e| "#{e.content} " }
                      ####@@logger.info (name_text)
                      
                       
                      author_text = page.search("span.category_text").map{ |e| "#{e.content} " }
                      ####@@logger.info (author_text )
                      url_text = []
                      page.search("span.about2_name a").each do |link|
                      url_text << link.attributes['href'].content
                      end 	
                      ####@@logger.info (url_text )
                      img_text = []
                      page.search("span.about2_name a img").each do |img|
                      img_text << img.attributes['src'].content
                      end
                     
                      ####@@logger.info (img_text )
                       
                      discount_text = page.search("span#ctl00_ContentPlaceHolder1_rptBook_ctl00_lblsaveprice").map{ |e| "#{e.content} " }
                      shipping_text = ""
                      prices=[]

                      (0...price_text.length).each do |i|

                          ####@@logger.info (price_text[i])
                          ####@@logger.info (author_text[i])
                          ####@@logger.info (name_text[i])
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                          else
                                          weight_author=0
                                          weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                          weight = weight_name + weight_author

                          end      
                          final_price = price_text[i].to_s.gsub(/[A-Za-z:,\s]/,'').gsub(/^[.]/,'')
                          final_price=final_price.tr('/-','')
                                                           
                          if (weight > 1) then
                            price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.rightbooks.in/"+url_text[i], :source=>'Rightbooks', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                       end
              rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
              end
              prices
          end



     def parse_coinjoos(page,query,type)
              ###@@logger.info('Parsing coinjoos')
              begin 
                  price_text = page.search("div.listItem div.searchRes div.resItem form p span.info i strong").map { |e| "#{e.content}" }
                  ##@@logger.info (price_text)
                  name_text = page.search("div.searchRes div.resItem h2 a.bookIcon").map{ |e| "#{e.content} " }
                  ##@@logger.info (name_text)
                  author_text = page.search("div.listItem div.searchRes div.resItem h3 a b").map {|e| "#{e.content}" }
                  ##@@logger.info (author_text )
                  url_text = []
                  page.search("div.searchRes div.resItem h2 a.bookIcon").each do |link|
                      url_text << link.attributes['href'].content
                  end 	
                  ##@@logger.info (url_text )
                  img_text = []
                  page.search("div.variant-image img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  ##@@logger.info (img_text )
                  prices=[]
                  
                  discount_text = page.search("div.listItem div.searchRes div.resItem form p span.info i b").map {|e| "#{e.content}" }
                  shipping_text = page.search("div.listItem div.searchRes div.resItem form p span.info span span:first-child").map {|e| "#{e.content}" }

                  i=0 
                  #(0...price_text.length).each do |i|
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                      end      
                                            final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.coinjoos.com"+url_text[i], :source=>'Coinjoos', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  #end
                  rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                  end
                  prices
          end

    def parse_fotocenter(page,query,type)
              ###@@logger.info('Parsing fotocenter')
              begin 
            
                  price_text = page.search("span.productSpecialPrice").map { |e| "#{e.content}" }
                   
                  ##@@logger.info (price_text)
                  name_text = page.search("div.searchRes div.resItem h2 a.bookIcon").map{ |e| "#{e.content} " }
                  ##@@logger.info (name_text)
                  author_text = page.search("div.listItem div.searchRes div.resItem h3 a b").map {|e| "#{e.content}" }
                  ##@@logger.info (author_text )
                  url_text = []
                  page.search("div.searchRes div.resItem h2 a.bookIcon").each do |link|
                      url_text << link.attributes['href'].content
                  end 	
                  ##@@logger.info (url_text )
                  img_text = []
                  page.search("div.variant-image img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  ##@@logger.info (img_text )
                  prices=[]
                  
                  discount_text = page.search("div.listItem div.searchRes div.resItem form p span.info i b").map {|e| "#{e.content}" }
                  shipping_text = page.search("div.listItem div.searchRes div.resItem form p span.info span span:first-child").map {|e| "#{e.content}" }

                  i=0 
                  #(0...price_text.length).each do |i|
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
			                    weight = weight_name + weight_author

                      end      
                                            final_price = price_text[i].to_s.tr('A-Za-z.,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.coinjoos.com"+url_text[i], :source=>'Coinjoos', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  #end
                  rescue => ex
                        ####@@logger.info ("#{ex.class} : #{ex.message}")
                        ####@@logger.info (ex.backtrace)
                  end
                  prices
          end
      def parse_greendust(page,query,type)
              ##@@logger.info('Parsing greendust')
              begin 
                  price_text = page.search("span.home_gdprice").map { |e| "#{e.content}" }
                  ##@@logger.info (price_text)
                  name_text = page.search("td.home_pname").map{ |e| "#{e.content} " }
                  ##@@logger.info (name_text)
                  author_text = ""
                  ##@@logger.info (author_text )
                  url_text = []
                  page.search("td.home_pname a").each do |link|
                      url_text << link.attributes['href'].content
                  end   
                  ##@@logger.info (url_text )
                  img_text = []
                  page.search("div.variant-image img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  ##@@logger.info (img_text )
                  prices=[]
                  
                  discount_text = page.search("span.home_save").map {|e| "#{e.content}" }
                  shipping_text = ""

                  i=0 
                  (0...price_text.length).each do |i|
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author

                      end      
                                final_price = price_text[i].to_s.tr('A-Za-z.:,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Greendust', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        ##@@logger.info ("#{ex.class} : #{ex.message}")
                        ##@@logger.info (ex.backtrace)
                  end
                  prices
          end

      def parse_retailmart(page,query,type)
              ##@@logger.info('Parsing retailmart')
              begin 
                  price_text = page.search("div.product_box1:nth-child(3) div.sale_text").map { |e| "#{e.content}" }
                  ##@@logger.info (price_text)
                  name_text = page.search("form#product_action_form_grid div.product_box1 div div span.truncateName a").map{ |e| "#{e.content} " }
                  ##@@logger.info (name_text)
                  author_text = ""
                  ##@@logger.info (author_text )
                  url_text = []
                  page.search("form#product_action_form_grid div.product_box1 div div span.truncateName a").each do |link|
                      url_text << link.attributes['href'].content
                  end   
                  ##@@logger.info (url_text )
                  img_text = []
                  page.search("div.pic_box1 a img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  ##@@logger.info (img_text )
                  prices=[]
                  
                  discount_text = ""
                  shipping_text = ""

                  i=0 
                  (0...price_text.length).each do |i|
                      ####@@logger.info (price_text[i])
                      ####@@logger.info (author_text[i])
                      ####@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author

                      end      
                                final_price = price_text[i].to_s.tr('A-Za-z.:,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Retailmart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        ##@@logger.info ("#{ex.class} : #{ex.message}")
                        ##@@logger.info (ex.backtrace)
                  end
                  prices
          end

      def parse_ibazaar(page,query,type)
              #@@logger.info('Parsing ibazaar')
              begin 
                  price_text=[]
                  page.search("span.prdsym").each do |item|
                    price_text << item.next.text.strip
                  end  
                  #@@logger.info (price_text)
                  name_text = page.search("a.verdana_11").map{ |e| "#{e.content} " }
                  #@@logger.info (name_text)
                  author_text = ""
                  #@@logger.info (author_text )
                  url_text = []
                  page.search("a.verdana_11").each do |link|
                      url_text << link.attributes['href'].content
                  end   
                  #@@logger.info (url_text )
                  img_text = []
                  page.search("div.imgBox img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  #@@logger.info (img_text )
                  prices=[]
                  
                  discount_text = page.search("div#products div#content div.rtSelingBox div.newarvBox div.pptag").map { |e| "#{e.content}" }
                  shipping_text = ""

                  i=0 
                  (0...price_text.length).each do |i|
                      #@@logger.info (price_text[i])
                      #@@logger.info (author_text[i])
                      #@@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author

                      end      
                                final_price = price_text[i].to_s.tr(',','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'iBazaar', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        #@@logger.info ("#{ex.class} : #{ex.message}")
                        #@@logger.info (ex.backtrace)
                  end
                  prices
          end

      def parse_buytheprice(page,query,type)
              @@logger.info('Parsing buytheprice')
             # @@logger.info(page)
              begin 
                  price_text=[]
                  page.search("div.product-sp").each do |item|
                    #price_text << item.next.text.strip
                    @@logger.info(item.text)
                    price_text<<item.text
                  end  
              #    @@logger.info (price_text)
                  name_text = page.search("div.product-block h2.product-name").map{ |e| "#{e.content} " }
              #    @@logger.info (name_text)
                  author_text = ""
              #    @@logger.info (author_text )
                  url_text = []
                  page.search("div.product-block a").each do |link|
                      url_text << link.attributes['href'].content
                  end   
                  @@logger.info ("URL #{url_text}" )
                  img_text = []
                  page.search("div.product-block a img").each do |img|
                      img_text << img.attributes['src'].content
                  end
                  @@logger.info (img_text )
                  prices=[]
                  
                  discount_text = page.search("div.product-block div.product-save").map { |e| "#{e.content}" }
                  shipping_text = ""

                  i=0 
                  (0...price_text.length).each do |i|
                      @@logger.info (price_text[i])
                      @@logger.info (author_text[i])
                      @@logger.info (name_text[i])
                      if (name_text[i] == nil && author_text[i] != nil) then
                            weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                      elsif (name_text[i] !=nil && author_text[i] == nil) then
                            weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                      else
                                weight_author=0
                                weight_name,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                                weight_author,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                                weight = weight_name + weight_author

                      end      
                                final_price = price_text[i].to_s.tr('[A-Z][a-z].,','')
                      if (weight > 1) then
                        price_info = {:price => digitize_price(final_price),:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.buytheprice.com"+url_text[i], :source=>'BuyThePrice', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                        prices.push(price_info)
                      end
                  end
                  rescue => ex
                        @@logger.info ("#{ex.class} : #{ex.message}")
                        @@logger.info (ex.backtrace)
                  end
                  prices
          end



#---------------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------Helpers to find correct URL to parse------------------------------------
          def get_flipkart_url(query, type)
                  what = type[:search_type]
                  ###@@logger.info("Flipkart URL")
                  ###@@logger.info(what)
                  if what == 'movies' then
                      url="http://www.flipkart.com/search-movie?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'mobiles' then
                      url="http://www.flipkart.com/search-mobile?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'books' then
                      url="http://www.flipkart.com/search-book?dd=0&query=#{query[:search_term]}&Search=Search"
                  elsif what == 'cameras' then
                      url="http://www.flipkart.com/search-cameras?query=#{query[:search_term]}&from=all&searchGroup=cameras"
                  elsif what == 'computers' then
                      url="http://www.flipkart.com/search-computers?query=#{query[:search_term]}&from=all&searchGroup=computers"                          
                  else
                      url = "http://www.flipkart.com/search.php?query=#{query[:search_term]}&from=all"
                  end
                  ###@@logger.info(url)
                  url
          end
          def get_infibeam_url(query,type)
                  what = type[:search_type]
                  ###@@logger.info("Infibeam URL")
                  ###@@logger.info(what)
 
                  if what == 'movies' then
                      url = "http://www.infibeam.com/Media/search?q=#{query[:search_term]}"
                  elsif what == 'mobiles' then
                      url = "http://www.infibeam.com/Mobiles/search?q=#{query[:search_term]}"
                  elsif what == 'books' then
                      url = "http://www.infibeam.com/Books/search?q=#{query[:search_term]}"
                  elsif what == 'cameras' then
                      url = "http://www.infibeam.com/Cameras/search?q=#{query[:search_term]}"
                  elsif what == 'computers' then
                      url = "http://www.infibeam.com/Computers_Accessories/search?q=#{query[:search_term]}"    
                  else
                      url = "http://www.infibeam.com/search?q=#{query[:search_term]}"
                  end
                  ###@@logger.info(url)
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
                
                ##@@logger.info("ebay URL : #{url} ")
                url
           end

           def get_bookadda_url(query,type)
                url = "http://www.bookadda.com/search/#{query[:search_term]}"
                url
           end
           def get_tradeus_url(query,type)
                mtype = type[:search_type]

                if mtype =='mobiles' then  
                     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}&filters=cat:552"
                #elsif mtype=='movies' then
                #     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}?filters=tid%3A695"
                elsif mtype=='cameras' then
                     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}&filters=cat:381"
                elsif mtype=='books' then
                     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}&filters=cat:357&sort=fs_uc_sell_price:asc"
                elsif mtype=='computers' then
                     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}&filters=cat:551"                     
                else
                     url = "http://www.tradus.in/search/tradus_search/?query=#{query[:search_term]}"

                end  
                ###@@logger.info("tradeus url - #{url}")
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
              url= "http://www.letsbuy.com/advanced_search_result.php?keywords=#{query[:search_term]}&categories_id=&inc_subcat=&sortby="
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
           def get_coinjoos_url(query,type)
              url="http://www.coinjoos.com/search/keywords/#{query[:search_term]}"
              url
           end
           def get_moviemart_url(query,type)
              url="http://www.moviemart.in/sales/Search.aspx?Title_name=Stanley%20Ka%20Dabba&Cat=0&Lang=0&Rating=0&IsNew=2&Star=#{query[:search_term]}"
              url
           end
           def get_moserbaer_url(query,type)
              url="http://www.moserbaerhomevideo.com/title-search.htm?stimes=OK&language=5&CDTYPE=&category[]=ALL&searchin=MOV&keyword=#{query[:search_term]}&x=0&y=0&sbox=OK"
              url
           end
           def get_indiatimes_url(query,type)
              url="http://shopping.indiatimes.com/#{query[:search_term]}/search/ctl/20375476/"
              url
           end
     	     def get_sangeeta_url(query,type)
              url="http://www.sangeethamobiles.com/SearchResults.aspx?Search=#{query[:search_term]}&SearchCategory="
              url
           end
     	     def get_landmark_url(query,type)
          	  url="http://www.landmarkonthenet.com/product/SearchPaging.aspx?code=#{query[:search_term]}&type=0&num=0"
              url
           end
           def get_rightbooks_url(query,type)
           url="http://www.rightbooks.in/Product_search.asp?cid=1&fc=1&fsr=#{query[:search_term]}&pt=2&sc=INR"
           end
           def get_fotocenter_url(query,type)
            url="http://fotocentreindia.com/search.php?keywords=#{query[:search_term]}"
           end
           def get_greendust_url(query,type)
            url="http://www.greendust.com/advanced_search_result.php?keywords=#{query[:search_term]}&search.x=0&search.y=0"
            url
           end 
           def get_smartshopper_url(query,type)            
            url="http://smartshoppers.in/search&searchstring=#{query[:search_term]}"
            url
           end
           def get_retailmart_url(query,type)
            url="http://www.retailmart.com/#{query[:search_term]}/shopping.html"
            url
           end 
           def get_ibazaar_url(query,type)
            url="http://www.ibazaarindia.com/search_advance_results.php?_txtSearchText=#{query[:search_term]}&x=0&y=0"
            url            
           end 
           def get_buytheprice_url(query,type)
            url="http://www.buytheprice.com/search_products.php?product=#{query[:search_term]}"
            url            
           end

           def get_junglee_url(query,type)
            url="http://www.junglee.com/mn/search/junglee/?k=#{query[:search_term]}"
            url            
           end

#-------------------------------------------------------------------------------------------------------------------------------
          #Using - http://madeofcode.com/posts/69-vss-a-vector-space-search-engine-in-ruby 
          #def find_weight(source_string, search_string)
          #      ###@@logger.info("Trying to find weight...................................")
          #      search_string_de = de_canonicalize_isbn(search_string)
          #      @source_text = source_string
          #      source_array = [@source_text]

          #      engine = VSS::Engine.new(source_array)
          #      results= engine.search(search_string_de)
          #      ###@@logger.info(results)
          #      weight=0
          #      results.each do |e|
          #                weight = e.rank 
          #                ###@@logger.info (weight.class)
          #      end
          #      return weight,0
          #  end

        #Finds the relevance of the search result
        def find_weight(source_string, search_string)
             ###@@logger.info("...................................")
             # ##@@logger.info(source_string)
             # ##@@logger.info(search_string)
              weight,wt=0,0
              begin
              

                    search_string = strip_invalid_utf8_chars(search_string + ' ')[0..-2]
                    source_string = strip_invalid_utf8_chars(source_string + ' ')[0..-2]
                    
                    search_string = de_canonicalize_isbn(search_string)
                    source_string = tokenize(source_string).gsub(/\W/," ")
                    search_string = tokenize(search_string).gsub(/\W/," ")   
                    
                    m = LongestSubsequence.new(source_string.downcase)
                    weight = m.match(search_string.downcase)
                    
                    source_string = source_string.gsub("\n","").gsub("\t","").downcase
                    source_text = [source_string]
                    
                    engine = VSS::Engine.new(source_text)
                    results= engine.search(search_string.downcase)
                    ####@@logger.info(results)
                    results.each do |e|
                              weight = weight + e.rank 
                              ##@@logger.info (weight)
                    end
                    #m = Jaro.new(source_string)
                    #weight = weight + m.match(search_string)   
            
                    #wt = get_custom_weight(source_string.downcase, search_string.downcase)
                    #weight = weight + wt
                    # ##@@logger.info(source_string)
                    # ##@@logger.info(search_string)
                    ###@@logger.info("#{source_string} - #{search_string} : #{weight}")
              rescue => ex
                    ###@@logger.info ("#{ex.class} : #{ex.message}")
                    ###@@logger.info (ex.backtrace)
              end

              return weight+wt,0
        end


        def de_canonicalize_isbn(text)
              unless text.nil?
               text.to_s.gsub('+', ' ')
              end
        end

	    def proper_case(str)
		    st = str.to_s
		    #return st.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
		    #return str.titleize unless str.nil?

	    end

def get_custom_weight(source_string, search_string)

  
  # Assign 10 as weight for perfect word matches
  word_match_w = 10
  weight,cost =0,0
  freqs = Hash.new(0)
  filtered_source_string = ""
  # Check if all the words in search string are present in the target
  #Start with small search string   
  search_string.downcase.split.each do |t|
    cost = cost + 1
    source_string.downcase.split.each do |tt|
    #soundex always matches with numbers - need to ignore numbers. 
        if(soundex(tt) == soundex(t) and (/\d/.match(tt) == nil)) then
           ###@@logger.info("#{t} - #{tt} Matches")
        if freqs[t] == 0 then 
           weight = weight + word_match_w
           filtered_source_string << tt 
        end 
        freqs[t] += 1
    end
    #valid usecase for numbers like Nokia 5800
     if (/\d/.match(tt) != nil and t==tt) then
       ###@@logger.info("#{t} - #{tt} Matches")
       if freqs[t] == 0 then  
          weight = weight + word_match_w
          filtered_source_string << tt 
        end 
        freqs[t] += 1
     end
    end 

    weight

  end
  
  
   #reduce weight if there are duplicates
  #  freqs.each do |k,v|
  #         p k , v
  #         weight = weight - (v*word_match_w)
  #  end
  #p 'after removing duplicates' , weight
        soundex_source = soundex(source_string.downcase)
        soundex_target = soundex(search_string.downcase)
        if soundex_source[0] == soundex_target[0] then
                for xx in 1..soundex_source.length do
                  if soundex_source[xx] == soundex_target[xx] then
                      weight = weight + 1
                  end
                end
        end 
  puts 'after soundex match- '+ weight.to_s 
  #Match filtered source string on soundex
  if soundex(search_string.gsub(" ","")) == soundex(filtered_source_string) then
    weight += 5
  end
  puts 'after soundex match for filter- '+ weight.to_s 
  return weight, cost

end

def digitize_price(price)

  begin

    if price =~/\.00$/
      ##@@logger.info "Not changing #{price}"
      price
    else
      ##@@logger.info "changing #{price}"
      price.to_s<<".00"
      price
    end  
  rescue => ex
     ##@@logger.info ("#{ex.class} : #{ex.message}")
     ##@@logger.info (ex.backtrace)
  end
   
end


def soundex(string)
  copy = string.upcase.tr '^A-Z', ''
  return nil if copy.empty?
  first_letter = copy[0, 1]
  copy.tr_s! 'AEHIOUWYBFPVCGJKQSXZDTLMNR', '00000000111122222222334556'
  copy.sub!(/^(.)\1*/, '').gsub!(/0/, '')
  "#{first_letter}#{copy.ljust(3,"0")}"
end


	    def strip_invalid_utf8_chars(str)
          unless str.valid_encoding?
            buf = []
            str.each_char do |ch|
              
              buf << ch if ch.valid_encoding?
            end
            return buf.join
          else
            return str
          end
       end
       
       STOP_WORDS = %w[
                        a b c d e f g h i j k l m n o p q r s t u v w x y z
                        an and are as at be by for from has he in is it its
                        of on that the to was were will with upon without among
                      ].inject({}) { |h,v| h[v] = true; h }
  
    def tokenize(string)
      stripped = string.to_s.gsub(/[^a-z0-9\-\s\']/i, "") # remove punctuation
      #tokens = stripped.split(/\s+/).reject(&:blank?).map(&:downcase).map(&:stem)
      #tokens.reject { |t| STOP_WORDS.include?(t) }.uniq
      #string
    end

  end #-------------------self -end

end  #-------Generalsearch_improved -end



