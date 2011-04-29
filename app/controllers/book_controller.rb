class BookController < ApplicationController
  respond_to :html
  respond_to :json, :only => :view

  def view
    logger.info("Inside BookController.view")
    @isbn = canonicalize_isbn(params[:q])
    @type = params[:search_type]
    #@isbn = (params[:q])

    logger.info(@isbn)
    logger.info(@type)

    @searchby = 'isbn'

    if @isbn.nil? || !is_isbn(@isbn)
      @searchby = 'text'
      #render :text => 'Not Found', :status => 404
      #return
    else
      @searchby = 'isbn'
    end

    if @searchby == 'isbn'  
      
      @prices = Bookprice.new(:isbn => @isbn)
      @bookinfo = Rails.cache.fetch("amazon_info:#{@isbn}", :expires_in => 1.day) { AmazonInfo::book_info(@isbn) }
      if @bookinfo.nil?
        @bookinfo = Rails.cache.fetch("flipkart_info:#{@isbn}", :expires_in => 1.day) { FlipkartInfo::book_info(@isbn) }
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
       @prices = Generalsearch.new({:search_term => @isbn}, {:search_type => @type})
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
    #@stores = @stores.reject { |store, data| store == :uread } ## XXX HACK

    #respond_with(@stores) do |format|
    #  format.json do
    #    render :json => @stores
    #  end
    #end
  end


  private

  def canonicalize_isbn(text)
    unless text.nil?
     text.to_s.gsub(' ', '+')
    end
  end

  def is_isbn(text)
    /^[0-9]{9}[0-9xx]$/.match(text) or /^[0-9]{13}$/.match(text)
  end

end
