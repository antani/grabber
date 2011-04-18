#!/usr/bin/env ruby

class FlipkartInfo
  
  class << self
    @@logger = Logger.new(STDOUT)

    def book_info(isbn)
      url = "http://www.flipkart.com/search.php?query=#{isbn}"
      page = Mechanize.new.get(url)

      product_details = page.search("div.item_details span.product_details_values")
      unless product_details.blank?
        @@logger.info(product_details.to_xml)

        title     = product_details[0].try(:text).try(:strip) or ""
        authors   = product_details[1].try(:text).try(:strip) or ""
        publisher = product_details[6].try(:text).try(:strip) or ""
        lang  = product_details[8].try(:text).try(:strip) or ""
        pub_at = product_details[5].try(:text).try(:strip) or ""

      else
        return nil
      end

      image = nil
      image_tag = page.search("div#mprodimg-id img")
      unless image_tag.nil?
        image = image_tag.attr('src').text
      end

      content = page.search(".item_desc_text").text
      source = nil
      unless content.nil?
        source = "Description"
        content.gsub!(/top$/, '')
      end


      {
        :info_source => "flipkart",
        :title => title,
        :authors_as_string => authors,
        :publisher => publisher,
        :image => image,
        :detail_page => url,
        :review_source => source,
        :review_content => content,
        :published_at => pub_at,
        :language => lang,
      }
    end

  end
end
