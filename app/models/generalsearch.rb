#!/usr/bin/env ruby

require 'timeout'

class Generalsearch 

  NOT_AVAILABLE = 999_999
  @@logger = Logger.new(STDOUT)
  attr_accessor :search_term

  def initialize(given_search_term)
    @@logger.info("Initializing generalsearch")
    @@logger.info (given_search_term)
    self.search_term= given_search_term

  end
  # For usage with DelayedJob : Bookprice.new(:isbn => "9789380032825").perform
  def perform
    @@logger.info("Performing job for #{self.search_term}")
    prices = self.class.prices(self.search_term)
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
    
    def prices(query)
     #@price_arr = []
     #isbn = check_isbn(isbn)
      prices_array = self.searches.map { |name,search| [search.call(query)] }#.sort_by { |p| p[1][:price] }
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
        weight,cost=0,0

        search_string.downcase.split.each do |t|
          cost = cost + 1
          if(source_string.downcase.include? t) then
                  weight = weight + 1
          end
        end

        return weight,cost
    end
    def search_flipkart(query)
      @@logger.info("Search flipkart..")
      @@logger.info(query)
      url = "http://www.flipkart.com/search.php?query=#{query[:search_term]}"
      prices=[]
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
            price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :url=>"http://flipkart.com"+url_text[i], :source=>'Flipkart', :weight=>weight} 
            prices.push(price_info)
          end
        end
        prices
    end
    
    def search_infibeam(query)
      @@logger.info("Search infibeam..")
      @@logger.info(query)
      url = "http://www.infibeam.com/Books/search?q=#{query[:search_term]}"
      prices=[]
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
      prices
    end
    
    def search_rediff(query)
      @@logger.info("Search rediffbooks..")
      @@logger.info(query)
      url = "http://books.rediff.com/book/#{query[:search_term]}"
      page = self.fetch_page(url)
      prices=[]
      price_text = page.search("font#book-pric").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
      name_text = page.search("font#book-titl").map{ |e| "#{e.text} " }
      author_text = page.search("font#book-auth").map {|e| "#{e.text}" }
      url_text = page.search("div#prod-detail2 b a").map{|e| "#{e.text}" }
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
      prices
   end
   # Dont know why but we keep on getting execution expired from this site.
   def search_indiaplaza(query)
      @@logger.info("Search indiaplaza..")
      @@logger.info(query)
      prices=[]

      begin
      url = "http://www.indiaplaza.in/search.aspx?catname=Books&srchkey=&srchVal=#{query[:search_term]}"
      page = self.fetch_page(url)

      price_text = page.search("div.tier1box2 ul li:first-child span").map { |e| "#{e.text.tr('A-Za-z.,','')}" }
      name_text = page.search("ul.bookdetails li a").map{ |e| "#{e.text} " }
      author_text = page.search("ul.bookdetails li:nth-child(2)").map {|e| "#{e.text}" }
      url_text = page.search("ul.bookdetails li a").map{|e| "#{e.text}" }
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
            price_info = {:price => price_text[i],:author=>author_text[i], :name=>name_text[i], :url=>url_text[i], :source=>'Indiaplaza', :weight=>weight} 
            prices.push(price_info)
          end
 
      end
      rescue => ex
         #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
  end

      #This is the worst formed website and dangers lurk in every corner.
   def search_a1books(query)
      @@logger.info("Search a1books..")
      @@logger.info(query)
      url ="http://www.a1books.co.in/searchresult.do?searchType=books&keyword=#{query[:search_term]}&fromSearchBox=Y&partnersite=a1india&imageField=Go"
      page = self.fetch_page(url)
      prices=[]
      begin
      price_text = page.search("span.salePrice").map { |e| "#{e.text.tr('A-Za-z,','')}" }
      name_text = page.search("table.section a.label").map{ |e| "#{e.text}" }
      author_text = page.search("table.section td[@width='100%']").map{ |e| "#{e.text}" }

    
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
            price_info = {:price => price_text[i],:author=>author, :name=>name_text[i], :url=>"", :source=>'A1Books', :weight=>weight} 
            prices.push(price_info)
          end
      end
      rescue => ex
        #Just ignore this error
        @@logger.info ("#{ex.class} : #{ex.message}")
      end
      prices
   end

  end

end
