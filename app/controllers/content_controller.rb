class ContentController < ApplicationController
  def index
    @@logger = Logger.new(STDOUT)

    @@logger.info("Inside ContentController.index.........................................................................................")
    begin
    #@top_books = TopBooks.new()
    @top_book_info = Rails.cache.fetch("top_book_info", :expires_in => 3.days) { TopBooks::book_info }
    @top_mobile_info = Rails.cache.fetch("top_mobile_info", :expires_in => 3.days) { TopMobiles::mobile_info }    
    @top_camera_info = Rails.cache.fetch("top_camera_info", :expires_in => 3.days) { TopCameras::camera_info }
    @top_movie_info = Rails.cache.fetch("top_movie_info", :expires_in => 3.days) { TopMovies::movie_info }        
    rescue => ex
        @@logger.info ("#{ex.class} : #{ex.message}")
        @@logger.info (ex.backtrace)

    end
  end

  def about
  end
end
