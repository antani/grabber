#!/usr/bin/env ruby

require 'timeout'
require 'amatch'
require 'nokogiri'

include Amatch

class Generalsearch_parallel

  NOT_AVAILABLE = 999_999
  @@logger = Logger.new(STDOUT)
  @@hydra = Typhoeus::Hydra.new
  attr_accessor :search_term,:search_type

  def initialize(given_search_term,search_type)
    ##@@logger.info("Initializing generalsearch.............................................................................................")
    ##@@logger.info (given_search_term)
    ##@@logger.info (search_type)

    self.search_term= given_search_term
    self.search_type= search_type
  end
  # For usage with DelayedJob : Bookprice.new(:isbn => "9789380032825").perform
  def perform
    ##@@logger.info("Performing job for #{self.search_term}")
    prices = self.class.prices(self.search_term,self.search_type)
    Rails.cache.write(self.cache_key, prices)
    prices
  end

  def cache_key
    "prices:#{self.search_term},#{self.search_type}".downcase
  end

  def number_of_stores
    self.class.searches.size
  end

  class << self
  
  
   def fetch_page(url)
   ##@@logger.info(url)
      begin
        Timeout::timeout(configatron.store_timeout) do
          return Mechanize.new.get(url)
        end
      rescue Exception => x
        #@@logger.info "ERROR in fetch_page : #{url} => #{x.message}"
      else
        nil
      end
    end

    def searches
      # e.g. ["search_a1books", "search_infibeam", "search_rediff"]
      functions = self.methods.map(&:to_s).select { |name| name =~ /^search_(\w+)$/ }.sort
      # e.g. [[:a1books, search_a1books], [:infibeam, search_infibeam], [:rediff, search_rediff]]
      functions.collect { |fname| [ fname.split("_")[1].to_sym, self.method(fname) ] }
      #schedule_requests
    end
    def names
      self.searches.map { |name, search| name.to_s }.sort.map(&:to_sym)
    end
    
    def prices(query,type)
     #@price_arr = []
     #isbn = check_isbn(isbn)
      prices_array = self.searches.map { |name,search| [search.call(query,type)] }#.sort_by { |p| p[1][:price] }
      price_array = prices_array.flatten
     # #@@logger.info(price_array)
     # #@@logger.info("-------------------------------------------")

#      price_array = price_array.sort_by { |p| [-p[:weight], p[:price] ] }
#      price_array


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
#      final_prices = final_prices.sort_by { |p|  }
      final_prices
   #   ##@@logger.info("Final Price------------------------------------")
   #   ##@@logger.info(final_prices)

#      final_prices = final_prices.sort_by { |p| p[:price].to_i }
#      ##@@logger.info(prices_array)
#      ##@@logger.info ("========================================================================================")
 
#      ##@@logger.info(prices_array)


#      [prices_array[0], prices_array[1].sort_by {|book| book[:price].to_i} ]

      #b= Hash[*prices_array]
      #      b.merge! (b) {|k,v| v.sort_by {|p| p[:price].to_i} }
      #b.to_a[0]
###@@logger.info ("=========================================================================")
#      ##@@logger.info (b)

=begin

      prices_array.each_with_index do |item, index|
        if ( index > 0 && index%2 == 0 ) then
          ##@@logger.info (item)
           final_prices.push(item)           
        end
      end
      prices_array.sort do  |a,b|
        a.price <=> b.price
      end
=end      


      #prices_array.each do |price_info|
      #  ##@@logger.info(price_info)
      #end
      #b
    #  final_prices
    end
def find_weight(source_string, search_string)
  search_string = de_canonicalize_isbn(search_string)
  #weight = search_string.longest_subsequence_similar(source_string)

  m = LongestSubsequence.new(source_string.downcase)
  weight = m.match(search_string.downcase)

  @@logger.info ("search----------------")
  @@logger.info search_string
  @@logger.info ("source----------------")
  @@logger.info source_string
  @@logger.info ("weight----------------")
  @@logger.info weight
  return weight,0
end



def find_weight_1(source_string, search_string)

  p source_string
  search_string = de_canonicalize_isbn(search_string)
  p search_string
  # Assign 10 as weight for perfect word matches
  word_match_w = 10
  weight,cost =0,0
  freqs = Hash.new(0)
  filtered_source_string = ""

  if source_string.downcase.include? (search_string.downcase) then
	#@@logger.info "----------------direct hit------------------------"
	weight = 100
	return weight, 1
  end

  # Check if all the words in search string are present in the target
  #Start with small search string   
  search_string.downcase.split.each do |t|
    cost = cost + 1
    source_string.downcase.split.each do |tt|
    #soundex always matches with numbers - need to ignore numbers. 
            if(soundex(tt) == soundex(t) and (/\d/.match(tt) == nil)) then
                    p t + " - " + tt + " Matches"
                    weight = weight + word_match_w
                    freqs[t] += 1
                    filtered_source_string << tt 
            end
    #valid usecase for numbers like Nokia 5800
            if (/\d/.match(tt) != nil and t==tt) then
                    p t + " - " + tt + " Matches"
                    weight = weight + word_match_w
                    freqs[t] += 1
                    filtered_source_string << tt 
            end
    end 
  end
  #@@logger.info 'after adding characters- '+ weight.to_s
  
  p filtered_source_string
    #reduce weight if there are duplicates
  #  freqs.each do |k,v|
  #          p k , v
  #          weight = weight - (v*word_match_w)
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
  #@@logger.info 'after soundex match- '+ weight.to_s 
  #Match filtered source string on soundex
  if soundex(search_string.gsub(" ","")) == soundex(filtered_source_string) then
    weight += 5
  end
  #@@logger.info 'after soundex match for filter- '+ weight.to_s 
  return weight, cost

end
   #-------------------------------------------------------------------------------------------------------------

   def schedule_requests
      #@@logger.info ("Scheduling requests")

      # e.g. ["search_a1books", "search_infibeam", "search_rediff"]
      functions = self.methods.map(&:to_s).select { |name| name =~ /^search_(\w+)$/ }.sort
      # e.g. [[:a1books, search_a1books], [:infibeam, search_infibeam], [:rediff, search_rediff]]
      calls = functions.collect { |fname| [ fname.split("_")[1].to_sym, self.method(fname) ] }	
      requests= calls.map { |name,search| [search.call(self.search_term,self.search_type)] }
      requests.each do |r|
        #@@logger.info (r)
	@@hydra.queue r
      end


	r.on_complete do |response|
	      #@@logger.info ("Reqs running")
	end
      @@hydra.run


   end
   #Bad hack to run hydra.run in the end
   def search_zz(query,type)
      #@@logger.info("Running hydra")
      
      @@hydra.run	
   end

   #------------------------------------------------------------------------------------------------------------------------------------------------    
   def search_flipkart(query,type)
      ##@@logger.info("Search flipkart..")
      ##@@logger.info(query)
      ##@@logger.info(type)

      what = type[:search_type]
      if what == 'movies' then
          url="http://www.flipkart.com/search-movie?dd=0&query=#{query[:search_term]}&Search=Search"
      elsif what == 'mobiles' then
          url="http://www.flipkart.com/search-mobile?dd=0&query=#{query[:search_term]}&Search=Search"
      elsif what == 'books' then
          url="http://www.flipkart.com/search-book?dd=0&query=#{query[:search_term]}&Search=Search"
      elsif what == 'cameras' then
          url="http://www.flipkart.com/search-cameras?query=#{query[:search_term]}&from=all&searchGroup=cameras"
      else
          url = "http://www.flipkart.com/search.php?query=#{query[:search_term]}&from=all"
      end
      #hydra = Typhoeus::Hydra.hydra
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
        begin
	    doc= response.body
            page = Nokogiri::HTML::parse(doc)
            price_text = page.search("div#search_results div.fk-srch-item div.dlvry-det .price").map { |e| "#{e.content}" }
            ##@@logger.info (price_text)
            name_text = page.search("div#search_results div.fk-srch-item h2 a:first-child").map{ |e| "#{e.content} " }
            ##@@logger.info (name_text)
            author_text = page.search("span.head-tail a:first-child b").map {|e| "#{e.content}" }
            ##@@logger.info (author_text )
	    url_text = []
            page.search("div#search_results div.fk-srch-item h2 a").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            ##@@logger.info (url_text )
            img_text = []
            page.search("div.rposition img").each do |img|
		img_text << img.attributes['src'].content
	    end
	   
            ##@@logger.info (img_text )
            discount_text = page.css("span.discount").map { |e| "#{e.content}" }
            ##@@logger.info (discount_text )
            shipping_text = page.css("div.ship-det b:nth-child(2)").map { |e| "#{e.content}" } 
            ##@@logger.info (shipping_text )
            ##@@logger.info (price_text.length)


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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://flipkart.com"+url_text[i], :source=>'Flipkart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
          end
       end
      @@hydra.queue request
      prices
   end
   #------------------------------------------------------------------------------------------------------------------------------------------------    
   # TODO - infibeam has different CSS for mobiles and books - fix that
   #------------------------------------------------------------------------------------------------------------------------------------------------    
   def search_infibeam(query,type)
      @@logger.info("Search infibeam..")
      @@logger.info(query)
      @@logger.info(type)

      what = type[:search_type]
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
      #hydra = Typhoeus::Hydra.hydra
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
      begin
  	      doc= response.body
              page = Nokogiri::HTML::parse(doc)
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
	      discount_text ="" 
	      shipping_text =""
	      (0...price_text.length).each do |i|
                  @@logger.info(price_text[i])
                  @@logger.info(name_text[i])
		  if (name_text[i] == nil && author_text[i] != nil) then
		        weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
		  elsif (name_text[i] !=nil && author_text[i] == nil) then
		        weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
		  else
		        weight,cost = find_weight(name_text[i]+" "+author_text[i], "#{query[:search_term]}" )
		  end      

		  if (weight > 0) then
		    price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :img=>img_text[i],:url=>"http://infibeam.com"+url_text[i], :source=>'Infibeam', :weight=>weight, :discount=>discount_text, :shipping => shipping_text} 
		    prices.push(price_info)
		  end
	 
	      end
	      rescue => ex
		@@logger.info ("#{ex.class} : #{ex.message}")
	      end
	    
     end
      @@hydra.queue request
      prices
    end
  #------------------------------------------------------------------------------------------------------------------------------------------------    
   def search_rediff(query,type)
      #@@logger.info("Search rediff..")
      #@@logger.info(query)
      #@@logger.info(type)
      prices=[]
      mtype = type[:search_type]
      if mtype != 'books' then
              ##@@logger.info ('----------------Ignoring search on Rediff---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'Rediff', :weight => -999}
              prices.push(price_info)
              return prices
      end

      url = "http://books.rediff.com/book/#{query[:search_term]}"
      #hydra = Typhoeus::Hydra.hydra
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            page = Nokogiri::HTML::parse(doc)
            price_text = page.search("font#book-pric").map { |e| "#{e.content}" }
            #@@logger.info (price_text)
            name_text = page.search("font#book-titl").map{ |e| "#{e.content} " }
            #@@logger.info (name_text)
            author_text = page.search("font#book-auth").map {|e| "#{e.content}" }
            #@@logger.info (author_text )
	    url_text = []
            page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail2 b a").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            #@@logger.info (url_text )
            img_text = []
            page.search("html body div#container div#bookscontainer div#center_cont div#prod_detail div#prod_detail1 a img").each do |img|
		img_text << img.attributes['src'].content
	    end
	   
            #@@logger.info (img_text )
            discount_text = page.css("span.discount").map { |e| "#{e.content}" }
            #@@logger.info (discount_text )
            shipping_text = page.css("div.ship-det b:nth-child(2)").map { |e| "#{e.content}" } 
            #@@logger.info (shipping_text )
            #@@logger.info (price_text.length)


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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Rediff', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
          end
       end
      @@hydra.queue request
      prices
   end

  #--------------------------------------------------------------------------------------------------------------------------------------
   def search_indiaplaza(query,type)
      #@@logger.info("Search indiaplaza..")
      #@@logger.info(query)
      #@@logger.info(type)

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
      #hydra = Typhoeus::Hydra.hydra
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

            price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.content}" }
            #@@logger.info (price_text)
            name_text = page.search("ul.bookdetails li a").map{ |e| "#{e.content} " }
            #@@logger.info (name_text)
            author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
            #@@logger.info (author_text )
	    url_text = []
            page.search("ul.bookdetails li a").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            #@@logger.info (url_text )
            img_text = []
            page.search("div.tier1box1 img").each do |img|
		img_text << img.attributes['src'].content
	    end
	   
            #@@logger.info (img_text )
            discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
            #@@logger.info (discount_text )
            shipping_text = ""


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
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
           #@@logger.info (ex.backtrace)
          end
       end
      @@hydra.queue request
      prices
   end

  #TODO--------------------------------------------------------------------------------------------------------------------------------------
   def dont_search_a1books(query,type)
      #@@logger.info("Search a1books..")
      #@@logger.info(query)
      #@@logger.info(type)

      what = type[:search_type]

      prices=[]
      if what != 'books' then
              ##@@logger.info ('----------------Ignoring search on a1books---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'Rediff', :weight => -999}
              prices.push(price_info)
              return prices
      end    
      url ="http://www.a1books.co.in/searchresult.do?searchType=books&keyword=#{query[:search_term]}&fromSearchBox=Y&partnersite=a1india&imageField=Go"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

      price_text = page.search("span.salePrice").map { |e| "#{e.text.tr('A-Za-z,','')}" }
      name_text = page.search("table.section a.label").map{ |e| "#{e.text}" }
      author_text = page.search("table.section td[@width='100%']").map{ |e| "#{e.text}" }
      url_text = page.search("table.section a.label[@href]").map{|e| e['href'] }
      discount_text ="" 
      shipping_text =""










            price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.content}" }
            #@@logger.info (price_text)
            name_text = page.search("ul.bookdetails li a").map{ |e| "#{e.content} " }
            #@@logger.info (name_text)
            author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
            #@@logger.info (author_text )
	    url_text = []
            page.search("ul.bookdetails li a").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            #@@logger.info (url_text )
            img_text = []
            page.search("div.tier1box1 img").each do |img|
		img_text << img.attributes['src'].content
	    end
	   
            #@@logger.info (img_text )
            discount_text = page.search("div.tier1box2 ul li:nth-child(3) span").map { |e| "#{e.content}" }
            #@@logger.info (discount_text )
            shipping_text = ""


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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.indiaplaza.com"+url_text[i], :source=>'A1Books', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
           #@@logger.info (ex.backtrace)
          end
       end
      @@hydra.queue request
      prices
   end
  #--------------------------------------------------------------------------------------------------------------------------------------
   def search_nbcindia(query,type)
      #@@logger.info("Search nbcindia..")
      #@@logger.info(query)
      #@@logger.info(type)
      prices=[]
      what = type[:search_type]
      if what != 'books' then
              ##@@logger.info ('----------------Ignoring search on nbcindia---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'NBCindia', :weight => -999}
              prices.push(price_info)
              return prices
      end
      url = "http://www.nbcindia.com/Search-books.asp?q=#{query[:search_term]}"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

            price_text = page.search("div.fieldset ul li:nth-child(2) font").map { |e| "#{e.content}" }
            #@@logger.info (price_text)
            name_text = page.search("div.fieldset ul li:first-child b").map{ |e| "#{e.content} " }
            #@@logger.info (name_text)
            author_text = page.search("div.fieldset ul li a u").map {|e| "#{e.content}" }
            #@@logger.info (author_text )
	    url_text = []
            page.search("div.fieldset ul li:first-child a:first-child").each do |link|
		url_text << link.attributes['href'].content
	    end 	
            #@@logger.info (url_text )
            img_text = []
            page.search("div.imageset img").each do |img|
		img_text << img.attributes['src'].content
	    end
            #@@logger.info (img_text )
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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"http://www.nbcindia.com/"+url_text[i], :source=>'NBCIndia', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
           #@@logger.info (ex.backtrace)
          end
       end
      @@hydra.queue request
      prices
   end
   #--------------------------------------------------------------------------------------------------------------------------------------
   def search_pustak(query,type)
      #@@logger.info("Search pustak..")
      #@@logger.info(query)
      #@@logger.info(type)
      prices=[]
      what = type[:search_type]
      if what != 'books' then
              ##@@logger.info ('----------------Ignoring search on Pustak---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'Pustak', :weight => -999}
              prices.push(price_info)
              return prices
      end
      url="http://pustak.co.in/pustak/books/search?searchType=book&q=#{query[:search_term]}&page=1&type=genericSearch"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Pustak', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
           #@@logger.info (ex.backtrace)
          end
       end
      @@hydra.queue request
      prices
   end
  #--------------------------------------------------------------------------------------------------------------------------------------
   def search_ebay(query,type)
      #@@logger.info("Search ebay..")
      #@@logger.info(query)
      #@@logger.info(type)

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
      #hydra = Typhoeus::Hydra.hydra
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

            price_text = page.search("div#ResultSet table.li td.prc").map { |e| "#{e.content}" }
            #@@logger.info (price_text)
            name_text = page.search("div#ResultSet table.li td:nth-child(2) a").map{ |e| "#{e.content} " }
            #@@logger.info (name_text)
            author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
            #@@logger.info (author_text )
	    url_text = []
            page.search("div#ResultSet table.li td:nth-child(2) a").each do |link|
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
                  price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'eBay', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
                  prices.push(price_info)
                end
              end
           rescue => ex
           #@@logger.info ("#{ex.class} : #{ex.message}")
           #@@logger.info (ex.backtrace)
          end
       end
      @@hydra.queue request
      prices
   end
   #--------------------------------------------------------------------------------------------------------------------------------------
   def search_bookadda(query,type)
      #@@logger.info("Search bookadda..")
      #@@logger.info(query)
      #@@logger.info(type)
      prices=[]
      what = type[:search_type]
      if what != 'books' then
              ##@@logger.info ('----------------Ignoring search on bookadda---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'bookadda', :weight => -999, :discount=>'fake',:shopping=>'fake'}
              prices.push(price_info)
              return prices
      end
      url = "http://www.bookadda.com/search/#{query[:search_term]}"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

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
       end
      @@hydra.queue request
      prices
   end
   #-------------------------------------------------------------------------------------------------------------------------
   def search_tradeus(query,type)
      #@@logger.info("Search tradeus..")
      #@@logger.info(query)
      #@@logger.info(type)

      what = type[:search_type]
      url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)


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
       end
      @@hydra.queue request
      prices
   end
   #--------------------------------------------------------------------------------------------------------------------------------------
   def search_crossword(query,type)
      #@@logger.info("Search crossword..")
      #@@logger.info(query)
      #@@logger.info(type)
      prices=[]
      what = type[:search_type]
      if what != 'books' then
              ##@@logger.info ('----------------Ignoring search on bookadda---------------------------------------------')
              price_info = {:price=> -999, :author=> 'fake',:name=>'fake', :img => 'fake', :url => 'fake', :source=>'crossword', :weight => -999, :discount=>'fake',:shopping=>'fake'}
              prices.push(price_info)
              return prices
      end
      url = "http://www.crossword.in/books/search?q=#{query[:search_term]}"
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	

      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)



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
       end
      @@hydra.queue request
      prices
   end
  #--------------------------------------------------------------------------------------------------------------------------------------
   def search_homeshop(query,type)
      #@@logger.info("Search homeshop..")
      #@@logger.info(query)
      #@@logger.info(type)

      mtype = type[:search_type]
      if mtype =='mobiles' then  
        url= "http://www.homeshop18.com/#{query[:search_term]}/gsm-handsets/categoryid:3027/search:#{query[:search_term]}"
      elsif mtype=='cameras' then
        url="http://camera.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
      else
        url="http://www.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
      end 
      #hydra = Typhoeus::Hydra.hydra
      #@@logger.info(url)
      request = Typhoeus::Request.new(url)	
      prices=[]
      request.on_complete do |response|
        begin
	    doc= response.body
            
            page = Nokogiri::HTML::parse(doc)

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
       end
      @@hydra.queue request
      prices
   end
 #--------------------------------------------------------------------------------------------------------------------------------------
   def search_letsbuy(query,type)
      #@@logger.info("Search letsbuy..")
      #@@logger.info(query)
      #@@logger.info(type)
      mtype = type[:search_type]
      ##@@logger.info(mtype)
      prices=[]
      # Letsbuy does not have books listed.
      if mtype != "books" then
              url= "http://www.letsbuy.com/advanced_search_result.php?keywords=#{query[:search_term]}"

	      #@@logger.info(url)
	      request = Typhoeus::Request.new(url)	

	      request.on_complete do |response|
		begin
		    doc= response.body
		    
		    page = Nokogiri::HTML::parse(doc)


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
	       end
         end
      @@hydra.queue request
      prices
   end
   #-----------------------------------------------------------------------------------------------------------------
   def search_futurebazaar(query,type)
      #@@logger.info("Search futurebazaar..")
      #@@logger.info(query)
      #@@logger.info(type)
      mtype = type[:search_type]
      ##@@logger.info(mtype)
      prices=[]
      url="http://www.futurebazaar.com/search/?q=#{query[:search_term]}"
	      #@@logger.info(url)
	      request = Typhoeus::Request.new(url)	

	      request.on_complete do |response|
		begin
		    doc= response.body
		    
		    page = Nokogiri::HTML::parse(doc)

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
	
         end
      @@hydra.queue request
      prices
   end
   #-----------------------------------------------------------------------------------------------------------------
   def search_adexmart(query,type)
      #@@logger.info("Search adexmart..")
      #@@logger.info(query)
      #@@logger.info(type)
      mtype = type[:search_type]
      ##@@logger.info(mtype)
      prices=[]
        if mtype != "books" then
      	      url="http://adexmart.com/search.php?orderby=position&orderway=desc&search_query=#{query[:search_term]}&submit_search=Search"

	      #@@logger.info(url)
	      request = Typhoeus::Request.new(url)	

	      request.on_complete do |response|
		begin
		    doc= response.body
		    
		    page = Nokogiri::HTML::parse(doc)
                    price_text = page.search("ul#product_list div.right_block span.price").map { |e| "#{e.text}" }
                    name_text = page.search("ul#product_list div.center_block h3 a").map{ |e| "#{e.text}" }
                    url_text = page.search("ul#product_list div.center_block h3 a[@href]").map{|e| e['href'] }
                    img_text = page.search("ul#product_list div.center_block img[@src]").map {|e| e['src'] }
                    discount_text = ""



		    price_text = page.search("ul#product_list div.right_block span.price").map { |e| "#{e.content}" }
		    #@@logger.info (price_text)
		    name_text = page.search("ul#product_list div.center_block h3 a").map{ |e| "#{e.content} " }
		    #@@logger.info (name_text)
		    author_text = page.search("ul.bookdetails li:nth-child(2) span").map {|e| "#{e.content}" }
		    #@@logger.info (author_text )
		    url_text = []
		    page.search("ul#product_list div.center_block h3 a	").each do |link|
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
		          price_info = {:price => final_price,:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>url_text[i], :source=>'Adexmart', :weight=>weight, :discount=>discount_text[i], :shipping => shipping_text[i]} 
		          prices.push(price_info)
		        end
		      end
		   rescue => ex
		   #@@logger.info ("#{ex.class} : #{ex.message}")
		   #@@logger.info (ex.backtrace)
		  end
            end	
         end
      @@hydra.queue request
      prices
   end

  #--------------------------------------------------------------------------------------------------------------------------------------

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
  #Soundex implemented as - http://www.infused.org/2005/12/23/soundex-for-ruby/
  def soundex(string)
  	copy = string.upcase.tr '^A-Z', ''
        return nil if copy.empty?
	  first_letter = copy[0, 1]
	  copy.tr_s! 'AEHIOUWYBFPVCGJKQSXZDTLMNR', '00000000111122222222334556'
	  copy.sub!(/^(.)\1*/, '').gsub!(/0/, '')
	  "#{first_letter}#{copy.ljust(3,"0")}"
  end


  end

end

