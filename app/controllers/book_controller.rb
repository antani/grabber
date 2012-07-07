class BookController < ApplicationController

  respond_to :html
  respond_to :json, :only => :view

  def view
    logger.info("Inside BookController.view.........................................................................................")
    @search_string = decanonicalize_isbn(params[:q])
    @isbn = canonicalize_isbn(params[:q])
    @type = params[:search_type]
    @sort = params[:sort]
    logger.info(@isbn)
    logger.info(@type)

    @searchby = 'isbn'

    if @isbn.nil? || !is_isbn(@isbn)
      @searchby = 'text'
    else
      @searchby = 'isbn'
    end

    if @searchby == 'isbn'  
      
          @prices = Bookprice.new(:isbn => @isbn)
          @bookinfo = Rails.cache.fetch("amazon_info:#{@isbn}", :expires_in => 3.hours) { AmazonInfo::book_info(@isbn) }
          if @bookinfo.nil?
            @bookinfo = Rails.cache.fetch("flipkart_info:#{@isbn}", :expires_in => 3.hours) { FlipkartInfo::book_info(@isbn) }
          end

          unless @bookinfo.nil?
            @bookseer = BookseerInfo::link(@bookinfo)

            @stores = Rails.cache.fetch(@prices.cache_key)
            if @stores.nil?
              # Check if book is already queued.
              if Delayed::Backend::Mongoid::Job.where(:handler => /#{@isbn}/).empty?
                logger.info("Book #{@isbn} has been queued")
                @prices.delay.perform
              else
                logger.info("Book #{@isbn} is already queued")
              end
            end
          end

          @not_available = Bookprice::NOT_AVAILABLE
     else

            @prices = Generalsearch_improved.new({:search_term => @isbn}, {:search_type => @type})
            tt = @type
            ss = decanonicalize_isbn(@isbn)
            #############################################
            #Easter egg
            #############################################
            if(ss.gsub(/\s+/, "").upcase=="CHEAPR" || ss.gsub(/\s+/, "").upcase=="CHEAPRCONTACTDETAILS")
              redirect_to "/about"
            end  
            @stores = Rails.cache.fetch(@prices.cache_key, :expires_in => 3.hours)
       	    #Save top_search or increase existing count of a search
            p = Topsearch.first(:conditions => {query: ss, type: @type})             
            q = Recentsearch.first(:conditions => {query: ss}) 

            if(!@stores.nil? && !@stores.empty? && q==nil) then            
              recentsearch = Recentsearch.create({:query => ss, :type=>tt, :ts=>Time.now})
              recentsearch.save
            end

  	        if p==nil then
                 if !@stores.nil? && !@stores.empty? then 
    		           topsearch = Topsearch.create ({:query=> ss, :type=> tt, :cnt=> 1})
    		           topsearch.save
                 end
              
            else
                  p.inc(:cnt,1)
    	            p.save
  	        end
            if @stores.nil?
              # Check if book is already queued.
              #if Delayed::Backend::Mongoid::Job.where(:handler => /#{@isbn}/).empty?
                logger.info("Book #{@isbn} has been queued")
                #    @prices.delay.perform
		            @prices.perform            
            end
            if @stores then 
                if @sort == "price_lowest" then
                    @stores = @stores.sort_by { |p| p[:price].to_i }
                elsif @sort == "default" then
                    @stores = Rails.cache.fetch(@prices.cache_key,  :expires_in => 3.hours)
                end
            end
    end   

    #@stores = @stores.reject { |store, data| store == :uread } ## XXX HACK

    #respond_with(@stores) do |format|
    #  format.json do
    #    render :json => @stores
    #  end
    #end
    #respond_to :js
  end


  private

  def canonicalize_isbn(text)
    unless text.nil?
     text.to_s.gsub(' ', '+')
    end
  end
  def decanonicalize_isbn(text)
    unless text.nil?
     text.to_s.gsub('+', ' ')
    end
  end


  def is_isbn(text)
    /^[0-9]{9}[0-9xx]$/.match(text) or /^[0-9]{13}$/.match(text)
  end

end
