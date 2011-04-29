#!/usr/bin/env ruby

require 'timeout'

class Generalsearch 

  NOT_AVAILABLE = 999_999
  @@logger = Logger.new(STDOUT)
  attr_accessor :search_term,:search_type

  def initialize(given_search_term,search_type)
    @@logger.info("Initializing generalsearch")
    @@logger.info (given_search_term)
    @@logger.info (search_type)

    self.search_term= given_search_term
    self.search_type= search_type
  end
  # For usage with DelayedJob : Bookprice.new(:isbn => "9789380032825").perform
  def perform
    @@logger.info("Performing job for #{self.search_term}")
    prices = self.class.prices(self.search_term,self.search_type)
    Rails.cache.write(self.cache_key, prices)
    prices
  end

  def cache_key
    "prices:#{self.search_term}"
  end

  def number_of_stores
    self.class.searches.size
  end

  class << self
  
  
   def fetch_page(url)
   @@logger.info(url)
      begin
        Timeout::timeout(configatron.store_timeout) do
          return Mechanize.new.get(url)
        end
      rescue Exception => x
        puts "ERROR in fetch_page : #{url} => #{x.message}"
      else
        nil
      end
    end

    def searches
      # e.g. ["search_a1books", "search_infibeam", "search_rediff"]
      functions = self.methods.map(&:to_s).select { |name| name =~ /^search_(\w+)$/ }.sort
      # e.g. [[:a1books, search_a1books], [:infibeam, search_infibeam], [:rediff, search_rediff]]
      functions.collect { |fname| [ fname.split("_")[1].to_sym, self.method(fname) ] }
    end
    def names
      self.searches.map { |name, search| name.to_s }.sort.map(&:to_sym)
    end
    
    def prices(query,type)
     #@price_arr = []
     #isbn = check_isbn(isbn)
      prices_array = self.searches.map { |name,search| [search.call(query,type)] }#.sort_by { |p| p[1][:price] }
      price_array = prices_array.flatten
      #@@logger.info(price_array)
      prices_array = price_array.sort_by { |p| p[:weight] }.reverse!
      top_weight = prices_array[0][:weight]
      @@logger.info(top_weight)
      top_prices=[]
      rest_prices=[]
      final_prices=[]
      prices_array.each do |tt|
        if(tt[:weight] == top_weight) then
         top_prices.push(tt) 
        else
         rest_prices.push(tt) 
        end
      end
      top_prices = top_prices.sort_by { |p| p[:price].to_i }
      rest_prices = rest_prices.sort_by { |p| p[:price].to_i }

      final_prices = top_prices + rest_prices
      @@logger.info(final_prices)

#      final_prices = final_prices.sort_by { |p| p[:price].to_i }
#      @@logger.info(prices_array)
#      @@logger.info ("========================================================================================")
 
#      @@logger.info(prices_array)


#      [prices_array[0], prices_array[1].sort_by {|book| book[:price].to_i} ]

      #b= Hash[*prices_array]
      #      b.merge! (b) {|k,v| v.sort_by {|p| p[:price].to_i} }
      #b.to_a[0]
#@@logger.info ("=========================================================================")
#      @@logger.info (b)

=begin

      prices_array.each_with_index do |item, index|
        if ( index > 0 && index%2 == 0 ) then
          @@logger.info (item)
           final_prices.push(item)           
        end
      end
      prices_array.sort do  |a,b|
        a.price <=> b.price
      end
=end      


      #prices_array.each do |price_info|
      #  @@logger.info(price_info)
      #end
      #b
      final_prices
    end
    def find_weight(source_string, search_string)
        #@@logger.info("-----------------------------Finding weight----------------------------------")
        weight,cost=0,0
        search_string = de_canonicalize_isbn(search_string)
        #@@logger.info(source_string)
        #@@logger.info(search_string)
 
        search_string.downcase.split.each do |t|
          cost = cost + 1
          if(source_string.downcase.include? t) then
                  weight = weight + 1
          end
        end

        return weight,cost
    end
    def search_flipkart(query,type)
      @@logger.info("Search flipkart..")
      @@logger.info(query)
      @@logger.info(type)

      what = type[:search_type]
      if what == 'movies' then
          url="http://www.flipkart.com/search-movie?dd=0&query=#{query[:search_term]}&Search=Search"
      elsif what == 'mobiles' then
          url="http://www.flipkart.com/search-mobile?dd=0&query=#{query[:search_term]}&Search=Search"
      else
          url = "http://www.flipkart.com/search.php?query=#{query[:search_term]}&from=all"
      end

      prices=[]
      begin
            page = self.fetch_page(url)
            price_text = page.search(".price").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
            name_text = page.search("div.right h2 a b").map{ |e| "#{e.text} " }
            author_text = page.search("span.head-tail a:first-child").map {|e| "#{e.text}" }
            url_text = page.search("div.right h2 a[@href]").map{|e| e['href']}
#        @@logger.info(name_text )
#        @@logger.info(price_text)
#        @@logger.info(author_text)
#        @@logger.info("--------------------------------------------------------------------------------")
            (0...price_text.length).each do |i|
                #@@logger.info (price_text[i])
                #@@logger.info (author_text[i])
                #@@logger.info (name_text[i])
                if (name_text[i] == nil && author_text[i] != nil) then
                      weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author_text[i] == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author_text[i], "#{query[:search_term]}" )
                end      

                if (cost == 1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :url=>"http://flipkart.com"+url_text[i], :source=>'Flipkart', :weight=>weight} 
                  prices.push(price_info)
                end
              end
      rescue => ex
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
 
        prices
    end
    
    def search_infibeam(query,type)
      @@logger.info("Search infibeam..")
      @@logger.info(query)
      @@logger.info(type)

      what = type[:search_type]
      if what == 'movies' then
          url = "http://www.infibeam.com/Movies/search?q=#{query[:search_term]}"
      elsif what == 'mobiles' then
          url = "http://www.infibeam.com/Mobiles/search?q=#{query[:search_term]}"
      else
          url = "http://www.infibeam.com/Books/search?q=#{query[:search_term]}"
      end

      prices=[]
      begin
      page = self.fetch_page(url)
      price_text = page.search("div.price b").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
      name_text = page.search("ul.search_result h2.simple a").map{ |e| "#{e.text} " }
      author_text = page.search("ul.search_result li a[@href^='/Books/search']").map {|e| "#{e.text}" }
      url_text = page.search("h2.simple a[@href]").map{|e| e['href']}

#       @@logger.info(name_text )
#       @@logger.info(price_text)
#       @@logger.info(author_text)
#       @@logger.info("--------------------------------------------------------------------------------")
      (0...price_text.length).each do |i|
          #@@logger.info (price_text[i])
          #@@logger.info (author_text[i])
          #@@logger.info (name_text[i])
          if (name_text[i] == nil && author_text[i] != nil) then
                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
          elsif (name_text[i] !=nil && author_text[i] == nil) then
                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
          else
                weight,cost = find_weight(name_text[i]+author_text[i], "#{query[:search_term]}" )
          end      


          if (cost==1 || weight > 1) then
            price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :url=>"http://infibeam.com"+url_text[i], :source=>'Infibeam', :weight=>weight} 
            prices.push(price_info)
          end
 
      end
      rescue => ex
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
    end
    # todo 
    def search_rediff(query,type)
      @@logger.info("Search rediffbooks..")
      @@logger.info(query)
      url = "http://books.rediff.com/book/#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
              price_text = page.search("font#book-pric").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
              name_text = page.search("font#book-titl").map{ |e| "#{e.text} " }
              author_text = page.search("font#book-auth").map {|e| "#{e.text}" }
              url_text = page.search("div#prod-detail2 b a[@href]").map{|e| e['href'] }
              (0...price_text.length).each do |i|
                  #@@logger.info (price_text[i])
                  #@@logger.info (author_text[i])
                  #@@logger.info (url_text[i])
                  if (name_text[i] == nil && author_text[i] != nil) then
                        weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
                  elsif (name_text[i] !=nil && author_text[i] == nil) then
                        weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                  else
                        weight,cost = find_weight(name_text[i]+author_text[i], "#{query[:search_term]}" )
                  end      


                  if (cost==1 || weight > 1) then
                    price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :url=>url_text[i], :source=>'Rediff', :weight=>weight} 
                    prices.push(price_info)
                  end
         
              end
      rescue => ex
         #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end

      prices
   end
   # Dont know why but we keep on getting execution expired from this site.
   def search_indiaplaza(query,type)
      @@logger.info("Search indiaplaza..")
      @@logger.info(query)
      @@logger.info(type)

      what = type[:search_type]
      if what == 'movies' then
          url= "http://www.indiaplaza.com/newsearch/search.aspx?srchval=#{query[:search_term]}&Store=movies"
      elsif what == 'mobiles' then
          url= "http://www.indiaplaza.com/newsearch/search.aspx?srchval=#{query[:search_term]}&Store=mobiles"
      else
          url = "http://www.indiaplaza.in/search.aspx?catname=Books&srchkey=&srchVal=#{query[:search_term]}"
      end
      prices=[]
#a[@href]").map{|e| e['href']}

      begin
            
      page = self.fetch_page(url)

      price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
      name_text = page.search("ul.bookdetails li a").map{ |e| "#{e.text} " }
      author_text = page.search("ul.bookdetails li:nth-child(2)").map {|e| "#{e.text}" }
      url_text = page.search("ul.bookdetails li a[@href]").map{|e| e['href'] }
      (0...price_text.length).each do |i|
          @@logger.info (price_text[i])
          @@logger.info (author_text[i])
          @@logger.info (name_text[i])
          @@logger.info (url_text[i])
          author_text[i] = author_text[i].gsub('Author:', '')

          if (name_text[i] == nil && author_text[i] != nil) then
                weight,cost = find_weight(author_text[i], "#{query[:search_term]}" )
          elsif (name_text[i] !=nil && author_text[i] == nil) then
                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
          else
                weight,cost = find_weight(name_text[i]+author_text[i], "#{query[:search_term]}" )
          end      


          if (cost==1 || weight > 1) then
            price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :url=>"http://www.indiaplaza.com"+url_text[i], :source=>'Indiaplaza', :weight=>weight} 
            prices.push(price_info)
          end
 
      end
      rescue => ex
         #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
  end
   # todo
   #This is the worst formed website and dangers lurk in every corner.
   def search_a1books(query,type)
      @@logger.info("Search a1books..")
      @@logger.info(query)
      url ="http://www.a1books.co.in/searchresult.do?searchType=books&keyword=#{query[:search_term]}&fromSearchBox=Y&partnersite=a1india&imageField=Go"
      page = self.fetch_page(url)
      prices=[]
      begin
      price_text = page.search("span.salePrice").map { |e| "#{e.text.tr('A-Za-z,','')}" }
      name_text = page.search("table.section a.label").map{ |e| "#{e.text}" }
      author_text = page.search("table.section td[@width='100%']").map{ |e| "#{e.text}" }
      url_text = page.search("table.section a.label[@href]").map{|e| e['href'] }

    
      (0...price_text.length).each do |i|
          author = author_text[i]
          name = name_text[i].strip
          search_index = author.index(name) 
          if search_index != nil then 
            author = author[search_index+name.length..author.length]
          end
          if (name_text[i] == nil && author != nil) then
                weight,cost = find_weight(author, "#{query[:search_term]}" )
          elsif (name_text[i] !=nil && author == nil) then
                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
          else
                weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
          end      

          if (cost==1 || weight > 1) then
            price_info = {:price => price_text[i],:author=>proper_case(author), :name=>proper_case(name_text[i]), :url=>"http://a1books.co.in"+url_text[i], :source=>'A1Books', :weight=>weight} 
            prices.push(price_info)
          end
      end
      rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   end
     
   def search_nbcindia(query,type)
      @@logger.info("Search nbcindia..")
      @@logger.info(query)
 
      url = "http://www.nbcindia.com/Search-books.asp?q=#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.fieldset ul li:nth-child(2) font").map { |e| "#{e.text.tr('A-Za-z,','')}" }
            name_text = page.search("div.fieldset ul li:first-child b").map{ |e| "#{e.text}" }
            author_text = page.search("div.fieldset ul li:first-child a:nth-child(2)").map{ |e| "#{e.text}" }
            url_text = page.search("div.fieldset ul li:first-child a:first-child[@href]").map{|e| e['href'] }
#a[@href]").map{|e| e['href']}

            
            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>"http://www.nbcindia.com/"+url_text[i], :source=>'NBC India', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   end

   def search_pustak(query,type)
      @@logger.info("Search pustak..")
      @@logger.info(query)
      url="http://pustak.co.in/pustak/books/search?searchType=book&q=#{query[:search_term]}&page=1&type=genericSearch"
      #url = "http://www.pustak.co.in/pustak/books/product?bookId=#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.prod_search_coll_holder div.search_landing_right_col span.prod_pg_prc_font").map { |e| "#{e.text.tr('A-Za-z,','')}" }
            name_text = page.search("div.prod_search_coll_holder div.search_landing_right_col a:first-child").map{ |e| "#{e.text}" }
            author_text = page.search("div.prod_search_coll_holder div.search_landing_right_col span#author:first-child").map{ |e| "#{e.text}" }
            url_text = page.search("div.prod_search_coll_holder div.search_landing_right_col a:first-child[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>"http://pustak.co.in"+url_text[i], :source=>'Pustak', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices

   end
   def dont_search_coralhub(isbn)
      @@logger.info("Search coralhub..")
      @@logger.info(query)
      url = "http://www.coralhub.com/SearchResults.aspx?pindex=1&cat=0&search=#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.prod_search_coll_holder div.search_landing_right_col span.prod_pg_prc_font").map { |e| "#{e.text.tr('A-Za-z,','')}" }
            name_text = page.search("div.prod_search_coll_holder div.search_landing_right_col a:first-child").map{ |e| "#{e.text}" }
            author_text = page.search("div.prod_search_coll_holder div.search_landing_right_col span#author:first-child").map{ |e| "#{e.text}" }
            url_text = page.search("div.prod_search_coll_holder div.search_landing_right_col a:first-child[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>"http://pustak.co.in"+url_text[i], :source=>'Coral Hub', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   end

   def search_ebay(query,type)
      @@logger.info("Search ebay..")
      @@logger.info(query)
      url="http://shop.ebay.in/?_from=R40&_trksid=m570&_nkw=#{query[:search_term]}&_sacat=See-All-Categories"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div#ResultSet table.li td.prc").map { |e| "#{e.text.tr('A-Za-z,','')}" }
            name_text = page.search("div#ResultSet table.li td:nth-child(2) a").map{ |e| "#{e.text}" }
            url_text = page.search("div#ResultSet table.li td:nth-child(2) a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                price_sub = price_text[i]
                search_index = name_text[i].index('by')
                if search_index != nil then
                    search_index = search_index + 'by'.length
                    name = name_text[i]
                    author = name[search_index..name.length]
                    name = name[0..search_index-'by'.length]
                else
                    author = nil
                    name = name_text[i]
                end
                if (name == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name !=nil && author == nil) then
                      weight,cost = find_weight(name, "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_sub[1..price_sub.length],:author=>proper_case(author), :name=>proper_case(name), :url=>url_text[i], :source=>'eBay India', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
 
   end


   def search_bookadda(query,type)
      @@logger.info("Search Bookadda..")
      @@logger.info(query)
      url = "http://www.bookadda.com/search/#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.deliveryinfo span.ourpriceredtext").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("div.searchpagebooktitle h2").map{ |e| "#{e.text}" }
            author_text = page.search("span.searchbookauthor a").map{ |e| "#{e.text}" }
            url_text = page.search("div.searchpagebooktitle a:first-child[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1)  && ( price_text[i].to_i > 0) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>url_text[i], :source=>'Book Adda', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
 
   end

   def search_tradus(query,type)
      @@logger.info("Search Tradeus..")
      @@logger.info(query)
      url = "http://www.tradus.in/search/tradus_search/#{query[:search_term]}?solrsort=fs_uc_sell_price asc"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.deliveryinfo span.ourpriceredtext").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("div.search_prod_col tr td:nth-child(2) a:first-child").map{ |e| "#{e.text}" }
            #There is no author text in the search result
            #author_text = page.search("div.searchpagebooktitle a:first-child").map{ |e| "#{e.text}" }
            url_text = page.search("div.search_prod_col tr td:nth-child(2) a:first-child a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>"", :name=>name_text[i], :url=>"http://tradeus.in/"+url_text[i], :source=>'Trade us', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   
   end
   def search_jumadi(query,type)
      @@logger.info("Search Jumadi..")
      @@logger.info(query)
      url = "http://www.jumadi.in/#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.catDesc span#our_price_display").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("div.catDesc span.prodTitle a").map{ |e| "#{e.text}" }
            author_text = page.search("div.catDesc span.prodAuthor a").map{ |e| "#{e.text}" }
            url_text = page.search("div.catDesc span.prodTitle a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>url_text[i], :source=>'Jumadi', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   end

   def dont_search_coinjoos(query)
      @@logger.info("Search Coinjoos..")
      @@logger.info(query)
      url = "http://www.coinjoos.com/product/books/#{query[:search_term]}/1/"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("div.catDesc span#our_price_display").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("div.catDesc span.prodTitle a").map{ |e| "#{e.text}" }
            author_text = page.search("div.catDesc span.prodAuthor a").map{ |e| "#{e.text}" }
            url_text = page.search("div.catDesc span.prodTitle a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>url_text[i], :source=>'Coinjoos', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
    end
    def dont_search_friendsofbooks(isbn)
      @@logger.info("Search Friends of books..")
      @@logger.info(query)
      url = "http://www.friendsofbooks.com/store/index.php?main_page=advanced_search_result&search_in_description=1&keyword=#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            common_text = page.search ("div#productListing tr td:nth-child(2) h2:first-child").map{ |e| "#{e.text}" }
            price_text = page.search("span.productSpecialPrice").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
         #a[@href]").map{|e| e['href']}

            (0...common_text.length).each do |i|
                txts = common_text[i].split('by')

                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>url_text[i], :source=>'Friends of Books', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
    end

    def search_crossword(query,type)
      @@logger.info("Search Crossword..")
      @@logger.info(query)
      url = "http://www.crossword.in/books/search?q=#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("ul#search-result-items li span.variant-final-price").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("ul#search-result-items li span.variant-title").map{ |e| "#{e.text}" }
            author_text = page.search("ul#search-result-items li span.ctbr-name").map{ |e| "#{e.text}" }
            url_text = page.search("ul#search-result-items li span.variant-title a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|
                author = author_text[i]
                if (name_text[i] == nil && author != nil) then
                      weight,cost = find_weight(author, "#{query[:search_term]}" )
                elsif (name_text[i] !=nil && author == nil) then
                      weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )
                else
                      weight,cost = find_weight(name_text[i]+author, "#{query[:search_term]}" )
                end      

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>"http://crossword.in/"+url_text[i], :source=>'Crossword', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
 
    end

    def search_homeshop(query,type)
      @@logger.info("Search HomeShop18..")
      @@logger.info(query)
      url= "http://www.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("span.srh_rslt_hsrate").map { |e| "#{e.text.tr('A-Za-z,.:','')}" }
            name_text = page.search("span.srh_rslt_title a").map{ |e| "#{e.text}" }
            url_text = page.search("span.srh_rslt_title a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|

                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>"", :name=>proper_case(name_text[i]), :url=>url_text[i], :source=>'Homeshop18', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
 
    end

    def dont_search_landmark(query,type)
      @@logger.info("Search Landmark..")
      @@logger.info(query)
      url= "http://www.homeshop18.com/#{query[:search_term]}/search:#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      begin
            price_text = page.search("span.srh_rslt_hsrate").map { |e| "#{e.text.tr('A-Za-z,.','')}" }
            name_text = page.search("span.srh_rslt_title a").map{ |e| "#{e.text}" }
            url_text = page.search("span.srh_rslt_title a[@href]").map{|e| e['href'] }
         #a[@href]").map{|e| e['href']}

            (0...price_text.length).each do |i|

                weight,cost = find_weight(name_text[i], "#{query[:search_term]}" )

                if (cost==1 || weight > 1) then
                  price_info = {:price => price_text[i],:author=>"", :name=>proper_case(name_text[i]), :url=>url_text[i], :source=>'Homeshop18', :weight=>weight} 
                  prices.push(price_info)
                end
            end
            rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
 
    end


  #--------------------------------------------------------------------------------------------------------------------------------------
  def proper_case(str)
    st = str.to_s
    return st.split(/\s+/).each{ |word| word.capitalize! }.join(' ')  
  end
  def de_canonicalize_isbn(text)
    unless text.nil?
     text.to_s.gsub('+', ' ')
    end
  end


  end

end
