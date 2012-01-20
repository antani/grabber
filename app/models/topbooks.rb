class Topbooks

    class << self
	    @@logger = Logger.new(STDOUT)
	    def parse_flipkart(page)      			
        begin  
          prices=[]
          @@logger.info("Parse Flipkart")
          
          name_text = page.search("div.fk-product-thumb a.title").map{ |e| "#{e.content} " }                      
          author_text = page.search("div.fk-product-thumb span.fk-item-category").map{ |e| "#{e.content} " }
          img_text = []

          page.search("div.fk-product-thumb img").each do |img|
            @@logger.info(img)
            img_text << img.attributes['src'].content
          end

          (0...name_text.length).each do |i|
            @@logger.info(name_text[i])                          
            @@logger.info(author_text[i])

            #Strip invalid UTF-8 Characters
            price_info = {:price =>"",:author=> proper_case(author_text[i]), :name=>proper_case(name_text[i]), :img => img_text[i],:url=>"", :source=>"", :weight=>"", :discount=>"",:shipping=>""} 
            prices.push(price_info)
          end

        rescue => ex
          @@logger.info ("#{ex.class} : #{ex.message}")
          @@logger.info (ex.backtrace)
        end
        #@@logger.info(prices)
        prices
            end

 

   def proper_case(str)
    #st = str.to_s.gsub(/\x0A\x0D/,'').rstrip
    st = str.to_s.strip
   end
            def book_info
              #@@logger.info("Get Top Books from Flipkart")
              url = "http://www.flipkart.com/books"
              req_top= Typhoeus::Request.new(url,:timeout=> 5000)      
              req_top.on_complete do |response|
              #  @@logger.info('Top Book response')
              #  @@logger.info(response.code)    # http status code
              #  @@logger.info(response.time)    # time in seconds the request took

                if response.success?
                  doc= response.body
                  page = Nokogiri::HTML::parse(doc)
                  page
                else
                  page="failed"
                end  
              end
              hydra = Typhoeus::Hydra.new
              hydra.queue req_top
              hydra.run

              parse_flipkart(req_top.handled_response) unless req_top.handled_response =="failed"
          end

    end
end