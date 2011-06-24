require 'nokogiri'
require 'typhoeus'
require 'amatch'
include Amatch

class Parser
     @@search_query = "wodehouse+what+ho"
     @@search_type = "books"
          def perform
              ##@@logger.info("Performing job for #{self.search_term}")
              prices = self.prices()
              #Rails.cache.write(self.cache_key, prices)
              prices
          end
          def prices()
                #prices_array = self.searches.map { |name,search| [search.call(query,type)] }#.sort_by { |p| p[1][:price] }
                prices_array = queue_requests
                puts("Time to process prices : ")
                start_time = Time.now
                price_array = prices_array.flatten
               # #@@logger.info(price_array)
               # #@@logger.info("-------------------------------------------")
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
                puts(Time.now - start_time)
 
                final_prices
          end
          def queue_requests
                     hydra = Typhoeus::Hydra.new
                
                     url="http://www.flipkart.com/search-book?dd=0&query=#{@@search_query}&Search=Search"
                     req_flip= Typhoeus::Request.new(url)      
                     req_flip.on_complete do |response|
                            doc= response.body
                            #puts  doc
                            page = Nokogiri::HTML::parse(doc)
                            page
                     end
                     url="http://www.infibeam.com/Books/search?q=#{@@search_query}"
                     req_infibeam= Typhoeus::Request.new(url)      
                     req_infibeam.on_complete do |response|
                            doc= response.body
                            #puts  doc
                            page = Nokogiri::HTML::parse(doc)
                            page
                     end
                     hydra.queue req_flip
                     hydra.queue req_infibeam
                     start_time= Time.now
                     hydra.run
                     prices=[]
                     prices.push(parse_flip(req_flip.handled_response))
                     prices.push(parse_infibeam(req_infibeam.handled_response))
                     puts ("Time for executing requests...")
                     puts (Time.now - start_time)
                     prices
          end           
          def find_weight(source_string, search_string)
            search_string = de_canonicalize_isbn(search_string)
            m = LongestSubsequence.new(source_string.downcase)
            weight = m.match(search_string.downcase)

#  @@logger.info ("search----------------")
#  @@logger.info search_string
#  @@logger.info ("source----------------")
#  @@logger.info source_string
#  @@logger.info ("weight----------------")
#  @@logger.info weight
            return weight,0
          end
        def proper_case(str)
          #st = str.to_s
          #return st.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
          return str
        end
        def de_canonicalize_isbn(text)
          unless text.nil?
           text.to_s.gsub('+', ' ')
          end
        end
        def get_flip_url(query,type)

        end

        def parse_flip(page)
                      price_text = page.search("div#search_results div.fk-srch-item div.dlvry-det .price").map { |e| "#{e.content}" }
                      puts (price_text)
                      name_text = page.search("div#search_results div.fk-srch-item h2 a:first-child").map{ |e| "#{e.content} " }
                      puts (name_text)
                      author_text = page.search("span.head-tail a:first-child b").map {|e| "#{e.content}" }
                      puts (author_text )
                      url_text = []
                      page.search("div#search_results div.fk-srch-item h2 a").each do |link|
                          url_text << link.attributes['href'].content
                      end 	
                      puts (url_text )
                      img_text = []
                      page.search("div.rposition img").each do |img|
                          img_text << img.attributes['src'].content
                      end
                     
                      puts (img_text )
                      discount_text = page.css("span.discount").map { |e| "#{e.content}" }
                      puts (discount_text )
                      shipping_text = page.css("div.ship-det b:nth-child(2)").map { |e| "#{e.content}" } 
                      prices=[]
                      (0...price_text.length).each do |i|
                          if (name_text[i] == nil && author_text[i] != nil) then
                                weight,cost = find_weight(author_text[i], "#{@@search_query}" )
                          elsif (name_text[i] !=nil && author_text[i] == nil) then
                                weight,cost = find_weight(name_text[i], "#{@@search_query}" )
                          else
                                weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{@@search_query}" )
                          end      
                          final_price = price_text[i].to_s.tr('A-Za-z.,','')
                          if (weight > 0) then
                            price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://flipkart.com"+url_text[i], :source=>'Flipkart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                            prices.push(price_info)
                          end
                        end
                        prices
           
          end

          def parse_infibeam(page)
                        price_text = page.search("div.price b").map { |e| "#{e.content.tr('A-Za-z.,','')}" }
                        puts price_text
                        name_text = page.search("ul.search_result h2.simple a:first-child").map{ |e| "#{e.content} " }
                        puts name_text
                        author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.content}" }
                        puts author_text
                        url_text = []
                        page.search("ul.search_result h2.simple a:first-child").each do |link|
                           url_text << link.attributes['href'].content
                        end 	
                        puts url_text
                        img_text = []
                        page.search("ul.search_result div.img img:first-child").each do |img|
                           img_text << img.attributes['src'].content
                        end
                        discount_text ="" 
                        shipping_text =""

                        prices=[]
                        (0...price_text.length).each do |i|
                            #@@logger.info(price_text[i])
                            #@@logger.info(name_text[i])
                            if (name_text[i] == nil && author_text[i] != nil) then
                                  weight,cost = find_weight(author_text[i], "#{@@search_query}" )
                            elsif (name_text[i] !=nil && author_text[i] == nil) then
                                  weight,cost = find_weight(name_text[i], "#{@@search_query}" )
                            else
                                  weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{@@search_query}" )
                            end      

                            if (weight > 0) then
                              price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :img=>img_text[i],:url=>"http://infibeam.com"+url_text[i], :source=>'Infibeam', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
                              prices.push(price_info)
                            end
                         end
                         prices


          end
end


puts 'Starting test'
prices = Parser.new.perform
puts "-------------------------------"
puts prices
puts "-------------------------------"

